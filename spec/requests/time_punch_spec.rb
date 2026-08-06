require 'rails_helper'

RSpec.describe 'TimePunch', type: :request do
  let(:employee_user) { create(:employee).user }

  describe 'POST /employees/time_punches' do
    context "employee registers clock in" do
      it "Create the punch in the database" do
        post session_path, params: {
          email_address: employee_user.email_address,
          password: employee_user.password
        }

        post employees_time_punches_path, params: { kind: :clock_in }

        expect(TimePunch.last.kind).to eq("clock_in")
        expect(TimePunch.last.employee).to eq(employee_user.employee)
      end
    end

    context "The employee clocks out 15 minutes after clocking in" do
      it "create the punch in the database" do
        post session_path, params: {
          email_address: employee_user.email_address,
          password: employee_user.password
        }
        create(:time_punch, employee: employee_user.employee, kind: :clock_in, punched_at: 1.hour.ago)
        post employees_time_punches_path, params: { kind: :clock_out }

        expect(TimePunch.last.kind).to eq("clock_out")
        expect(TimePunch.last.employee).to eq(employee_user.employee)
      end
    end

    context "The employee clocks out after a 15-minute period has elapsed between clocking in and clocking out." do
      it "create the punch in the database" do
        post session_path, params: {
          email_address: employee_user.email_address,
          password: employee_user.password
        }
        create(:time_punch, employee: employee_user.employee, kind: :clock_in, punched_at: 1.hour.ago)
        post employees_time_punches_path, params: { kind: :clock_out }

        expect(TimePunch.last.kind).to eq("clock_out")
        expect(TimePunch.last.employee).to eq(employee_user.employee)
      end
    end

    context "The employee clocks out before a 15-minute period has elapsed between clocking in and clocking out." do
      it "not create the punch in the database" do
        post session_path, params: {
          email_address: employee_user.email_address,
          password: employee_user.password
        }
        create(:time_punch, employee: employee_user.employee, kind: :clock_in, punched_at: 10.minutes.ago)
        post employees_time_punches_path, params: { kind: :clock_out }

        expect(TimePunch.last.kind).not_to eq("clock_out")
        expect(TimePunch.last.employee).to eq(employee_user.employee)
      end
    end
  end
end