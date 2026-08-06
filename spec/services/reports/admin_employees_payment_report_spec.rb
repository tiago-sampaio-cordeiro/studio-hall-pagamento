require 'rails_helper'

RSpec.describe Reports::AdminEmployeesPaymentReport, type: :service do
  let(:employee) { create(:employee) }
  let(:range) { Date.new(2026, 1, 1).beginning_of_day..Date.new(2026, 1, 31).end_of_day }

  describe "payroll" do
    it "returns a result for each employee" do
      create(:time_punch, employee: employee, kind: :clock_in, punched_at: "2026-01-01 08:00:00")
      create(:time_punch, employee: employee, kind: :clock_out, punched_at: "2026-01-01 09:00:00")

      result = Reports::AdminEmployeesPaymentReport.new(range: range).call

      expect(result.length).to eq(1)
    end
    it "returns a result for each employee_id" do
      employee1 = create(:employee, :clt)
      employee2 = create(:employee, :freelancer)

      punch1_employee1 = create(:time_punch, employee: employee1, kind: :clock_in, punched_at: "2026-01-01 08:00:00")
      punch2_employee1 = create(:time_punch, employee: employee1, kind: :clock_out, punched_at: "2026-01-01 09:00:00")

      punch1_employee2 = create(:time_punch, employee: employee2, kind: :clock_in, punched_at: "2026-01-01 08:00:00")
      punch2_employee2 = create(:time_punch, employee: employee2, kind: :clock_out, punched_at: "2026-01-01 09:00:00")


      result = Reports::AdminEmployeesPaymentReport.new(range: range).call

      expect(result.map { |r| r[:employee].id }).to include(employee1.id, employee2.id)
    end

    it "return employee, hours and payment" do
      punch1 = create(:time_punch, employee: employee, kind: :clock_in, punched_at: "2026-01-01 08:00:00")
      punch2 = create(:time_punch, employee: employee, kind: :clock_out, punched_at: "2026-01-01 09:00:00")

      result = Reports::AdminEmployeesPaymentReport.new(range: range).call

      expect(result.first).to include(:employee, :hours, :amount)
    end

    it "return array nil when not there are punches in range" do
      result = Reports::AdminEmployeesPaymentReport.new(range: range).call
      expect(result).to eq([])
    end

    it "not include punches out of interval" do
      punch1 = create(:time_punch, employee: employee, kind: :clock_in, punched_at: "2027-01-01 08:00:00")
      punch2 = create(:time_punch, employee: employee, kind: :clock_out, punched_at: "2027-01-01 09:00:00")

      result = Reports::AdminEmployeesPaymentReport.new(range: range).call

      expect(result).to eq([])
    end

    it "calculate hours correctly" do
      punch1 = create(:time_punch, employee: employee, kind: :clock_in, punched_at: "2026-01-01 08:00:00")
      punch2 = create(:time_punch, employee: employee, kind: :clock_out, punched_at: "2026-01-01 09:00:00")

      result = Reports::AdminEmployeesPaymentReport.new(range: range).call

      expect(result.map { |r| r[:hours] }).to eq([1.0])

    end
  end
end