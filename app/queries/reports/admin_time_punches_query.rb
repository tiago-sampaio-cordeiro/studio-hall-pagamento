module Reports
  class AdminTimePunchesQuery
    def initialize(range:)
      @range = range
    end

    def call
      TimePunch
        .includes(:employee)
        .where(punched_at: @range)
        .order(:employee_id, :punched_at)
    end
  end
end