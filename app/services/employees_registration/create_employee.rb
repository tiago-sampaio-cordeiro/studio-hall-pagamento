module EmployeesRegistration
  class CreateEmployee
    attr_reader :errors

    def initialize(user_attrs:, employee_attrs:, user_id: nil)
      @user_attrs = user_attrs
      @employee_attrs = employee_attrs
      @user_id = user_id
      @errors = []
    end

    def call
      create_new_employee
    end

    def update
      update_employee
    end

    private

    attr_reader :user_attrs, :employee_attrs, :user_id

    def create_new_employee
      ActiveRecord::Base.transaction do
        user = User.create!(user_attrs)
        user.build_employee(employee_attrs).save!
      end
      true
    rescue ActiveRecord::RecordInvalid => e
      @errors = e.record.errors.full_messages
      false
    end

    def update_employee
      ActiveRecord::Base.transaction do
        user = User.find(user_id)
        user.update!(user_attrs)
        user.employee.update!(employee_attrs)
      end
      true
    rescue ActiveRecord::RecordNotFound
      @errors = ["Funcionário não encontrado"]
      false
    rescue ActiveRecord::RecordInvalid => e
      @errors = e.record.errors.full_messages
      false
    end
  end
end