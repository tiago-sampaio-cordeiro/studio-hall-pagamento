require 'rails_helper'

RSpec.describe Reports::EmployeeTimePunchesQuery, type: :query do
  let(:employee) { create(:employee) }
  let(:range) { Date.new(2026, 1, 1).beginning_of_day..Date.new(2026, 12, 31).end_of_day }

  describe "range" do
    it "returns only punches inside range" do
      create(:time_punch, employee: employee, kind: :clock_in, punched_at: "2026-01-01 08:00:00")
      create(:time_punch, employee: employee, kind: :clock_out, punched_at: "2026-01-01 09:00:00")
      create(:time_punch, employee: employee, kind: :clock_in, punched_at: "2027-01-01 08:00:00")
      create(:time_punch, employee: employee, kind: :clock_out, punched_at: "2027-01-01 09:00:00")

      result = Reports::EmployeeTimePunchesQuery.new(employee: employee,range: range).call

      expect(result.length).to eq(2)
      expect(result.map(&:punched_at).map(&:year)).to all(eq(2026))
    end

    it "not returns punches out of range" do
      create(:time_punch, employee: employee, kind: :clock_in, punched_at: "2026-01-01 08:00:00")
      create(:time_punch, employee: employee, kind: :clock_out, punched_at: "2026-01-01 09:00:00")
      create(:time_punch, employee: employee, kind: :clock_in, punched_at: "2027-01-01 08:00:00")
      create(:time_punch, employee: employee, kind: :clock_out, punched_at: "2027-01-01 09:00:00")

      result = Reports::EmployeeTimePunchesQuery.new(employee: employee,range: range).call

      expect(result.map { |r| r.punched_at}.map {|y| y.year}).not_to include(2027)
    end

    it "returns punches sorted by ascendent punched_at" do
      create(:time_punch, employee: employee, kind: :clock_in, punched_at: "2026-01-01 08:00:00")
      create(:time_punch, employee: employee, kind: :clock_out, punched_at: "2026-01-01 09:00:00")
      create(:time_punch, employee: employee, kind: :clock_in, punched_at: "2027-01-01 08:00:00")
      create(:time_punch, employee: employee, kind: :clock_out, punched_at: "2027-01-01 09:00:00")

      result = Reports::EmployeeTimePunchesQuery.new(employee: employee,range: range).call

      expect(result.first[:punched_at]).to eq(Time.zone.parse("2026-01-01 08:00:00"))
      expect(result.last[:punched_at]).to eq(Time.zone.parse("2026-01-01 09:00:00"))
    end

    it "returns punches of all employees" do
      employee1 = create(:employee)
      employee2 = create(:employee)

      create(:time_punch, employee: employee1, kind: :clock_in, punched_at: "2026-01-01 08:00:00")
      create(:time_punch, employee: employee1, kind: :clock_out, punched_at: "2026-01-01 09:00:00")
      create(:time_punch, employee: employee2, kind: :clock_in, punched_at: "2026-01-01 08:00:00")
      create(:time_punch, employee: employee2, kind: :clock_out, punched_at: "2026-01-01 09:00:00")

      result = Reports::EmployeeTimePunchesQuery.new(employee: employee1,range: range).call
      expect(result.map { |r| r[:employee_id]}).not_to include(employee2.id)
    end
  end
end