module Reports
  class EmployeeTimePunchesQuery
    def initialize(employee:, range:)
      @employee = employee
      @range    = range
    end

    def call
      TimePunch
        .where(employee: @employee)
        .where(punched_at: @range)
        .order(:punched_at)
    end
  end
end