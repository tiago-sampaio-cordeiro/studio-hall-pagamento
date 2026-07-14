module PaymentCalculation
  class HoursCalculator
    def initialize(punches:)
      @punches = punches.sort_by(&:punched_at)
    end

    def call
      clock_ins  = @punches.select(&:clock_in?)
      clock_outs = @punches.select(&:clock_out?)

      total_seconds = clock_ins.zip(clock_outs).sum do |clock_in, clock_out|
        next 0 unless clock_out
        clock_out.punched_at - clock_in.punched_at
      end

      total_seconds / 3600.0
    end
  end
end