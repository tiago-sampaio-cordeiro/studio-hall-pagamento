module Reports
  class AdminEmployeesPaymentReport
    def initialize(range:)
      @range = range
    end

    def call
      punches = Reports::AdminTimePunchesQuery.new(range: @range).call

      punches
        .group_by(&:employee) #
        .map do |employee, employee_punches|
        build_employee_result(employee, employee_punches)
      end
    end

    private

    def build_employee_result(employee, punches)
      hours = PaymentCalculation::HoursCalculator.new(punches: punches).call

      {
        employee: employee,
        hours: hours,
        amount: PaymentCalculation::Payment.new(employee: employee, worked_hours: hours).call
      }
    end

    def calculate_hours(punches)
      PaymentCalculation::HoursCalculator.new(punches: punches).call
    end

    def calculate_payment(employee)
      PaymentCalculation::Payment.new(employee: employee, range: @range).call
    end
  end
end