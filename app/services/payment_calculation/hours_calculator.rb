module PaymentCalculation
  class HoursCalculator
    MAX_SHIFT_SECONDS = 6 * 3600 # 6 horas — acima disso, provável ponto esquecido

    def initialize(punches:)
      @punches = punches.sort_by(&:punched_at)
    end

    def call
      total_seconds = 0
      open_clock_in = nil

      @punches.each do |punch|
        if punch.clock_in?
          # se já havia uma entrada aberta sem saída, ela é descartada
          # (ponto órfão: funcionário esqueceu de bater saída antes)
          open_clock_in = punch
        elsif punch.clock_out?
          if open_clock_in
            duration = punch.punched_at - open_clock_in.punched_at
            # descarta turnos absurdamente longos (provável ponto esquecido)
            total_seconds += duration if duration <= MAX_SHIFT_SECONDS
            open_clock_in = nil
          end
          # se não há clock_in aberto, é uma saída órfã: ignorada
        end
      end

      total_seconds / 3600.0
    end
  end
end