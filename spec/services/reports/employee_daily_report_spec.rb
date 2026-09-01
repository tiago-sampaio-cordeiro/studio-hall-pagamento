require 'rails_helper'

RSpec.describe Reports::EmployeeDailyReport, type: :service do
  let(:employee) { create(:employee) }
  let(:range) { Date.new(2026, 1, 1).beginning_of_day..Date.new(2026, 12, 31).end_of_day }

  describe "#call" do
    it "returns data grouped by date" do
      create(:time_punch, employee: employee, kind: :clock_in, punched_at: "2026-01-01 08:00:00")
      create(:time_punch, employee: employee, kind: :clock_out, punched_at: "2026-01-01 09:00:00")
      create(:time_punch, employee: employee, kind: :clock_in, punched_at: "2026-01-02 08:00:00")
      create(:time_punch, employee: employee, kind: :clock_out, punched_at: "2026-01-02 09:00:00")

      result = Reports::EmployeeDailyReport.new(employee: employee, range: range).call

      expect(result.length).to eq(2)
      expect(result.first[:date]).to eq(Date.new(2026, 1, 1))
      expect(result.last[:date]).to eq(Date.new(2026, 1, 2))
    end

    it "returns entries and exits formatted" do
      create(:time_punch, employee: employee, kind: :clock_in, punched_at: "2026-01-01 08:00:00")
      create(:time_punch, employee: employee, kind: :clock_out, punched_at: "2026-01-01 09:00:00")
      create(:time_punch, employee: employee, kind: :clock_in, punched_at: "2026-01-02 08:00:00")
      create(:time_punch, employee: employee, kind: :clock_out, punched_at: "2026-01-02 09:00:00")

      result = Reports::EmployeeDailyReport.new(employee: employee, range: range).call

      expect(result.first[:entries]).to eq(["08:00:00"])
      expect(result.first[:exits]).to eq(["09:00:00"])
    end

    it "returns total_hours formatted" do
      create(:time_punch, employee: employee, kind: :clock_in, punched_at: "2026-01-01 08:00:00")
      create(:time_punch, employee: employee, kind: :clock_out, punched_at: "2026-01-01 09:00:00")
      create(:time_punch, employee: employee, kind: :clock_in, punched_at: "2026-01-02 08:00:00")
      create(:time_punch, employee: employee, kind: :clock_out, punched_at: "2026-01-02 09:00:00")

      result = Reports::EmployeeDailyReport.new(employee: employee, range: range).call

      expect(result.first[:total_hours]).to eq("01:00:00")
      # expect(result.first[:total_hours]).to eq(["01:00:00"])

    end

    it "returns array nil when not there are punches" do
      result = Reports::EmployeeDailyReport.new(employee: employee, range: range).call
      expect(result).to eq([])
    end

    it "returns data sorted by date" do
      create(:time_punch, employee: employee, kind: :clock_in, punched_at: "2026-01-01 08:00:00")
      create(:time_punch, employee: employee, kind: :clock_out, punched_at: "2026-01-01 09:00:00")
      create(:time_punch, employee: employee, kind: :clock_in, punched_at: "2026-01-02 08:00:00")
      create(:time_punch, employee: employee, kind: :clock_out, punched_at: "2026-01-02 09:00:00")

      result = Reports::EmployeeDailyReport.new(employee: employee, range: range).call

      expect(result.first[:date]).to eq(Date.new(2026, 1, 1))
      expect(result.first[:entries]).to eq(["08:00:00"])
      expect(result.last[:date]).to eq(Date.new(2026, 1, 2))
      expect(result.last[:exits]).to eq(["09:00:00"])
    end

    it "calculates correctly when the clock in and clock out are on different dates" do
      create(:time_punch, employee: employee, kind: :clock_in, punched_at: "2026-01-01 23:30:00")
      create(:time_punch, employee: employee, kind: :clock_out, punched_at: "2026-01-02 00:30:00")

      result = Reports::EmployeeDailyReport.new(employee: employee, range: range).call

      expect(result.first[:total_hours]).to eq("01:00:00")
    end
  end
end