require 'rails_helper'

RSpec.describe PaymentCalculation::Payment, type: :service do
  let(:employee_clt) { create(:employee, :clt) }
  let(:employee_freelancer) { create(:employee, :freelancer) }
  let(:employee_freelancer2) { build(:employee, :freelancer, hourly_rate: nil) }

  describe "payment clt" do
    it "returns base salary when worked exactly 176 hours" do
      payment = PaymentCalculation::Payment.new(employee: employee_clt, worked_hours: 176).call
      expect(payment).to eq(2000)
    end

    it "return base salary with discount when there are missing hours" do
      payment = PaymentCalculation::Payment.new(employee: employee_clt, worked_hours: 170).call
      expect(payment).to eq(1955)
    end

    it "return base salary with added when there are extra hours" do
      payment = PaymentCalculation::Payment.new(employee: employee_clt, worked_hours: 180).call
      expect(payment).to eq(2060)
    end
  end

  describe "freelancer" do
    it "return payment when employee is freelancer" do
      payment = PaymentCalculation::Payment.new(employee: employee_freelancer, worked_hours: 100).call

      expect(payment).to eq(5000)
    end

    it "return 0 when freelancer is not hourly_rate defined" do
      payment = PaymentCalculation::Payment.new(employee: employee_freelancer2, worked_hours: nil).call
      expect(payment).to eq(0)
    end
  end
end