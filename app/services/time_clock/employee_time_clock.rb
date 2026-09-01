module TimeClock
  class EmployeeTimeClock
    def initialize(employee:, kind:, punched_at:)
      @employee = employee
      @kind = kind
      @punched_at = punched_at
    end

    def call
      register_time_clock
    end

    private
    attr_reader :employee, :kind, :punched_at

    def register_time_clock
      punch = TimePunch.create!(
        employee: employee,
        kind: kind,
        punched_at: punched_at,
      )
      Notification::PunchNotifier.new(employee: employee, punch: punch).call
      punch
    end
  end
end
