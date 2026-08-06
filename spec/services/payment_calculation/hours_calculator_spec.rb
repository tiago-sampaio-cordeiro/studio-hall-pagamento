require 'rails_helper'

RSpec.describe PaymentCalculation::HoursCalculator, type: :service do
  let(:employee) { create(:employee) }

  describe "#call" do
    it "calcula corretamente um par completo de entrada e saída" do
      clock_in = create(:time_punch, employee: employee, kind: :clock_in, punched_at: "2026-01-01 08:00:00.000")
      clock_out = create(:time_punch, employee: employee, kind: :clock_out, punched_at: "2026-01-01 09:00:00.000")
      punches = [clock_in, clock_out]

      result = PaymentCalculation::HoursCalculator.new(punches: punches).call

      expect(result).to eq(1.0)
    end

    it "ignora clock_in órfão que não tem clock_out correspondente" do
      clock_in1 = create(:time_punch, employee: employee, kind: :clock_in, punched_at: "2026-01-01 08:00:00.000")
      clock_out = create(:time_punch, employee: employee, kind: :clock_out, punched_at: "2026-01-01 09:00:00.000")
      clock_in2 = create(:time_punch, employee: employee, kind: :clock_in, punched_at: "2026-01-01 10:00:00.000")
      punches = [clock_in1, clock_out, clock_in2]

      result = PaymentCalculation::HoursCalculator.new(punches: punches).call

      expect(result).to eq(1.0)
    end

    it "retorna 0 se não houver pontos" do
      result = PaymentCalculation::HoursCalculator.new(punches: []).call

      expect(result).to eq(0)
    end

    it "calcula corretamente quando o turno atravessa a meia-noite" do
      clock_in = create(:time_punch, employee: employee, kind: :clock_in, punched_at: "2026-01-01 23:30:00.000")
      clock_out = create(:time_punch, employee: employee, kind: :clock_out, punched_at: "2026-01-02 00:30:00.000")
      punches = [clock_in, clock_out]

      result = PaymentCalculation::HoursCalculator.new(punches: punches).call

      expect(result).to eq(1.0)
    end

    it "descarta clock_ins duplicados seguidos, considerando só o mais recente antes do clock_out" do
      clock_in1 = build(:time_punch, employee: employee, kind: :clock_in, punched_at: "2026-01-01 08:00:00.000")
      clock_in2 = build(:time_punch, employee: employee, kind: :clock_in, punched_at: "2026-01-01 08:10:00.000")
      clock_in3 = build(:time_punch, employee: employee, kind: :clock_in, punched_at: "2026-01-01 08:20:00.000")
      clock_out = build(:time_punch, employee: employee, kind: :clock_out, punched_at: "2026-01-01 09:00:00.000")
      punches = [clock_in1, clock_in2, clock_in3, clock_out]

      result = PaymentCalculation::HoursCalculator.new(punches: punches).call

      # só conta a partir do último clock_in (08:20) até o clock_out (09:00) = 40min
      expect(result).to eq(40.0 / 60)
    end

    it "ignora clock_out órfão sem clock_in aberto correspondente" do
      clock_out = build(:time_punch, employee: employee, kind: :clock_out, punched_at: "2026-01-01 09:00:00.000")
      clock_in = build(:time_punch, employee: employee, kind: :clock_in, punched_at: "2026-01-01 10:00:00.000")
      clock_out2 = build(:time_punch, employee: employee, kind: :clock_out, punched_at: "2026-01-01 11:00:00.000")
      punches = [clock_out, clock_in, clock_out2]

      result = PaymentCalculation::HoursCalculator.new(punches: punches).call

      # o primeiro clock_out é órfão (ignorado); só conta 10:00 -> 11:00 = 1h
      expect(result).to eq(1.0)
    end

    it "descarta pares com duração acima do limite máximo de turno (provável ponto esquecido)" do
      clock_in = create(:time_punch, employee: employee, kind: :clock_in, punched_at: "2026-01-01 08:00:00.000")
      clock_out = create(:time_punch, employee: employee, kind: :clock_out, punched_at: "2026-01-01 23:00:00.000") # 15h
      punches = [clock_in, clock_out]

      result = PaymentCalculation::HoursCalculator.new(punches: punches).call

      expect(result).to eq(0)
    end

    it "conta normalmente um turno dentro do limite máximo (6h)" do
      clock_in = create(:time_punch, employee: employee, kind: :clock_in, punched_at: "2026-01-01 08:00:00.000")
      clock_out = create(:time_punch, employee: employee, kind: :clock_out, punched_at: "2026-01-01 13:00:00.000") # 5h
      punches = [clock_in, clock_out]

      result = PaymentCalculation::HoursCalculator.new(punches: punches).call

      expect(result).to eq(5.0)
    end

    it "soma corretamente múltiplos pares válidos no mesmo dia" do
      clock_in1 = create(:time_punch, employee: employee, kind: :clock_in, punched_at: "2026-01-01 08:00:00.000")
      clock_out1 = create(:time_punch, employee: employee, kind: :clock_out, punched_at: "2026-01-01 12:00:00.000")
      clock_in2 = create(:time_punch, employee: employee, kind: :clock_in, punched_at: "2026-01-01 13:00:00.000")
      clock_out2 = create(:time_punch, employee: employee, kind: :clock_out, punched_at: "2026-01-01 17:00:00.000")
      punches = [clock_in1, clock_out1, clock_in2, clock_out2]

      result = PaymentCalculation::HoursCalculator.new(punches: punches).call

      expect(result).to eq(8.0)
    end
  end
end