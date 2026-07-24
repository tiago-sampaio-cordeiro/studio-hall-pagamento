module Reports
  class EmployeeDailyReport
    MAX_SHIFT_SECONDS = 6 * 3600 # 6 horas — acima disso, provável ponto esquecido

    def initialize(employee:, range:)
      @employee = employee
      @range    = range
    end

    def call
      punches = Reports::EmployeeTimePunchesQuery.new(employee: @employee, range: @range).call
      pairs = build_pairs(punches)

      pairs
        .group_by { |pair| pair[:clock_in].punched_at.to_date }
        .map do |date, day_pairs|
        {
          date: date,
          entries: day_pairs.map { |p| p[:clock_in].punched_at.strftime("%H:%M:%S") },
          exits: day_pairs.map { |p| p[:clock_out]&.punched_at&.strftime("%H:%M:%S") }.compact,
          total_hours: format_duration(total_hours(day_pairs))
        }
      end
        .sort_by { |h| h[:date] }
    end

    private

    def build_pairs(punches)
      sorted_punches = punches.sort_by(&:punched_at)
      pairs = []
      open_clock_in = nil

      sorted_punches.each do |punch|
        if punch.clock_in?
          # entrada anterior sem saída correspondente é descartada como órfã
          open_clock_in = punch
        elsif punch.clock_out?
          if open_clock_in
            pairs << { clock_in: open_clock_in, clock_out: punch }
            open_clock_in = nil
          end
          # saída sem entrada aberta: ponto órfão, ignorado
        end
      end

      pairs
    end

    def total_hours(pairs)
      worked_seconds = pairs.sum do |pair|
        next 0 unless pair[:clock_in] && pair[:clock_out]
        duration = pair[:clock_out].punched_at - pair[:clock_in].punched_at
        # descarta turnos absurdamente longos (provável ponto esquecido)
        duration <= MAX_SHIFT_SECONDS ? duration : 0
      end
      (worked_seconds / 3600.0)
    end

    def format_duration(hours)
      total_seconds = (hours * 3600).to_i
      hh = total_seconds / 3600
      mm = (total_seconds % 3600) / 60
      ss = total_seconds % 60
      format("%02d:%02d:%02d", hh, mm, ss)
    end
  end
end