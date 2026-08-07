module PaymentCalculation
  class Payment
    STANDARD_MONTHLY_HOURS = 176

    def initialize(employee:, worked_hours:)
      @employee = employee
      @worked_hours = worked_hours
    end

    def call
      calculate_payment
    end

    private

    attr_reader :employee, :worked_hours

    def calculate_payment
      if employee.clt?
        calculate_clt_payment
      else
        calculate_freelancer_payment
      end
    end

    def calculate_clt_payment
      hours_difference = (STANDARD_MONTHLY_HOURS - worked_hours).abs
      fixed_salary = employee.salary

      if worked_hours < STANDARD_MONTHLY_HOURS
        fixed_salary - (hours_difference * 7.5)
      elsif worked_hours > STANDARD_MONTHLY_HOURS
        fixed_salary + (hours_difference * 15)
      else
        fixed_salary
      end
    end

    def calculate_freelancer_payment
      return 0 unless employee.hourly_rate
      worked_hours * employee.hourly_rate
    end
  end
end