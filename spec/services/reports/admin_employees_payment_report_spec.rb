require 'rails_helper'

RSpec.describe Reports::AdminEmployeesPaymentReport, type: :service do
  # Cria 2 turnos por dia (manhã + tarde), cada um ≤ 6h, respeitando a trava de turno máximo
  def create_workday(employee:, date:)
    create(:time_punch, employee: employee, kind: :clock_in, punched_at: "#{date} 08:00:00")
    create(:time_punch, employee: employee, kind: :clock_out, punched_at: "#{date} 12:00:00") # 4h manhã
    create(:time_punch, employee: employee, kind: :clock_in, punched_at: "#{date} 13:00:00")
    create(:time_punch, employee: employee, kind: :clock_out, punched_at: "#{date} 17:00:00") # 4h tarde
    # total: 8h/dia, cada turno individual de 4h (dentro do limite de 6h)
  end

  describe "payment" do
    it "returns a result for each employee" do
      employee = create(:employee)
      create_workday(employee: employee, date: "2026-08-05")

      range = Time.zone.parse("2026-08-01").beginning_of_day..Time.zone.parse("2026-08-31").end_of_day
      result = Reports::AdminEmployeesPaymentReport.new(range: range).call
      expect(result.length).to be >= 1
    end

    it "return employee, hours and payment" do
      employee = create(:employee)
      create_workday(employee: employee, date: "2026-08-05")

      range = Time.zone.parse("2026-08-01").beginning_of_day..Time.zone.parse("2026-08-31").end_of_day
      result = Reports::AdminEmployeesPaymentReport.new(range: range).call
      expect(result.first).to include(:employee, :hours, :amount)
    end

    it "calculate hours correctly" do
      employee = create(:employee)
      create_workday(employee: employee, date: "2026-08-05")

      range = Time.zone.parse("2026-08-01").beginning_of_day..Time.zone.parse("2026-08-31").end_of_day
      result = Reports::AdminEmployeesPaymentReport.new(range: range).call.find { |r| r[:employee] == employee }
      expect(result[:hours]).to be_within(0.01).of(8.0)
    end
  end

  describe "desconto e extra para CLT" do
    it "calcula desconto quando horas trabalhadas < 176h" do
      employee_clt = create(:employee, :clt, salary: 3000.0)

      # 20 dias × 8h/dia = 160h
      20.times do |i|
        day = 5 + i
        create_workday(employee: employee_clt, date: "2026-08-#{day.to_s.rjust(2, '0')}")
      end

      range = Time.zone.parse("2026-08-01").beginning_of_day..Time.zone.parse("2026-08-31").end_of_day
      result = Reports::AdminEmployeesPaymentReport.new(range: range).call.find { |r| r[:employee] == employee_clt }

      expect(result[:hours]).to be_within(0.1).of(160.0)
      # 160h < 176h → desconto = (176 - 160) * 7.5 = 120 → 3000 - 120 = 2880
      expect(result[:amount]).to eq(2880.0)
    end

    it "calcula extra quando horas trabalhadas > 176h" do
      employee_clt = create(:employee, :clt, salary: 3000.0)

      # 23 dias × 8h = 184h + 1 dia extra de 6h (turno único) = 190h
      23.times do |i|
        day = 1 + i
        create_workday(employee: employee_clt, date: "2026-08-#{day.to_s.rjust(2, '0')}")
      end
      create(:time_punch, employee: employee_clt, kind: :clock_in, punched_at: "2026-08-24 08:00:00")
      create(:time_punch, employee: employee_clt, kind: :clock_out, punched_at: "2026-08-24 14:00:00") # 6h exatas

      range = Time.zone.parse("2026-08-01").beginning_of_day..Time.zone.parse("2026-08-31").end_of_day
      result = Reports::AdminEmployeesPaymentReport.new(range: range).call.find { |r| r[:employee] == employee_clt }

      expect(result[:hours]).to be_within(0.1).of(190.0)
      # 190h > 176h → extra = (190 - 176) * 15 = 210 → 3000 + 210 = 3210
      expect(result[:amount]).to eq(3210.0)
    end

    it "retorna salário integral quando horas = 176h (exato)" do
      employee_clt = create(:employee, :clt, salary: 3000.0)

      # 22 dias × 8h = 176h
      22.times do |i|
        day = 1 + i
        create_workday(employee: employee_clt, date: "2026-08-#{day.to_s.rjust(2, '0')}")
      end

      range = Time.zone.parse("2026-08-01").beginning_of_day..Time.zone.parse("2026-08-31").end_of_day
      result = Reports::AdminEmployeesPaymentReport.new(range: range).call.find { |r| r[:employee] == employee_clt }

      expect(result[:hours]).to be_within(0.1).of(176.0)
      expect(result[:amount]).to eq(3000.0)
    end
  end

  describe "pagamento para Freelancer" do
    it "calcula pagamento como horas * hourly_rate" do
      employee_freelancer = create(:employee, :freelancer, hourly_rate: 50.0)

      # 20 dias × 8h = 160h
      20.times do |i|
        day = 1 + i
        create_workday(employee: employee_freelancer, date: "2026-08-#{day.to_s.rjust(2, '0')}")
      end

      range = Time.zone.parse("2026-08-01").beginning_of_day..Time.zone.parse("2026-08-31").end_of_day
      result = Reports::AdminEmployeesPaymentReport.new(range: range).call.find { |r| r[:employee] == employee_freelancer }

      expect(result[:hours]).to be_within(0.1).of(160.0)
      expect(result[:amount]).to eq(8000.0)
    end

    it "ignora desconto/extra para freelancer" do
      employee_freelancer = create(:employee, :freelancer, hourly_rate: 50.0)

      # 25 dias × 8h = 200h
      25.times do |i|
        day = 1 + i
        create_workday(employee: employee_freelancer, date: "2026-08-#{day.to_s.rjust(2, '0')}")
      end

      range = Time.zone.parse("2026-08-01").beginning_of_day..Time.zone.parse("2026-08-31").end_of_day
      result = Reports::AdminEmployeesPaymentReport.new(range: range).call.find { |r| r[:employee] == employee_freelancer }

      expect(result[:hours]).to be_within(0.1).of(200.0)
      expect(result[:amount]).to eq(10000.0)
    end
  end
end