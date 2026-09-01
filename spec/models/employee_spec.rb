require 'rails_helper'

RSpec.describe Employee, type: :model do
  let(:employee) { create(:employee) }
  let(:user) { create(:user) }

  describe "validations" do
    context "it valid with attributes clt" do
      it "employee is valid" do
        employee = build(:employee, :clt)
        expect(employee).to be_valid
      end
    end

    context "it valid with attributes freelancer" do
      it "employee is valid" do
        employee = build(:employee, :freelancer)
        expect(employee).to be_valid
      end
    end

    context "it invalid without contract type" do
      it "employee is invalid" do
        employee = build(:employee, contract_type: nil)
        expect(employee).not_to be_valid
      end
    end

    context "clt is invalid without salary" do
      it "employee clt is invalid" do
        employee = build(:employee, contract_type: :clt, salary: nil)
        expect(employee).not_to be_valid
      end
    end

    context "freelancer is invalid without hourly_rate" do
      it "employee freelancer is invalid" do
        employee = build(:employee, contract_type: :freelancer, hourly_rate: nil)
        expect(employee).not_to be_valid
      end
    end

    context "freelancer is invalid if your hourly rate is less than or equal to zero" do
      it "employee freelancer is invalid" do
        employee1 = build(:employee, contract_type: :freelancer, hourly_rate: 0)
        employee2 = build(:employee, contract_type: :freelancer, hourly_rate: -1)
        expect(employee1).not_to be_valid
        expect(employee2).not_to be_valid
      end
    end
  end

  describe "associations" do
    context "belongs to user" do
      it "it true" do
        employee = create(:employee, user: user)
        expect(employee.user).to eq(user)
      end
    end

    context "has many time punches" do
      it "it true" do
        employee = create(:employee)
        create(:time_punch, employee: employee, kind: :clock_in)
        create(:time_punch, employee: employee, kind: :clock_out)
        expect(employee.time_punches.count).to eq(2)
      end
    end
  end

  describe "next time kind" do
    context "when there are no punches" do
      it "returns clock_in" do
        employee = create(:employee)
        Current.session = employee.user.sessions.create!
        expect(employee.next_punch_kind).to eq("clock_in")
      end
    end

    context "when last punch is clock in" do
      it "returns clock_out" do
        employee = create(:employee)
        Current.session = employee.user.sessions.create!
        create(:time_punch, employee: employee, kind: :clock_in)
        expect(employee.next_punch_kind).to eq("clock_out")
      end
    end

    context "when last punch is clock_out" do
      it "returns clock_in" do
        employee = create(:employee)
        Current.session = employee.user.sessions.create!
        create(:time_punch, employee: employee, kind: :clock_in)
        create(:time_punch, employee: employee, kind: :clock_out)
        expect(employee.next_punch_kind).to eq("clock_in")
      end
    end
  end
end