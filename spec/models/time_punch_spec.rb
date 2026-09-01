require 'rails_helper'

RSpec.describe TimePunch, type: :model do
  let(:employee) { create(:employee) }

  describe "validations" do
    it "is valid with valid attributes" do
      punch = build(:time_punch, employee: employee)
      expect(punch).to be_valid
    end

    it "is invalid without punched_at" do
      punch = build(:time_punch, employee: employee, punched_at: nil)
      expect(punch).not_to be_valid
    end

    it "is invalid without kind" do
      punch = build(:time_punch, employee: employee, kind: nil)
      expect(punch).not_to be_valid
    end
  end

  describe "valid_sequence" do
    it "is invalid when two consecutive clock_ins" do
      create(:time_punch, employee: employee, kind: :clock_in, punched_at: 1.hour.ago)
      punch = build(:time_punch, employee: employee, kind: :clock_in, punched_at: Time.current)
      expect(punch).not_to be_valid
    end

    it "is invalid when two consecutive clock_outs" do
      create(:time_punch, employee: employee, kind: :clock_in, punched_at: 2.hours.ago)
      create(:time_punch, employee: employee, kind: :clock_out, punched_at: 1.hour.ago)
      punch = build(:time_punch, employee: employee, kind: :clock_out, punched_at: Time.current)
      expect(punch).not_to be_valid
    end

    it "is valid when clock_out follows clock_in" do
      create(:time_punch, employee: employee, kind: :clock_in, punched_at: 1.hour.ago)
      punch = build(:time_punch, employee: employee, kind: :clock_out, punched_at: Time.current)
      expect(punch).to be_valid
    end

    it "is invalid when first punched_at is clock_out" do
      punch = build(:time_punch, employee: employee, kind: :clock_out, punched_at: Time.current)
      expect(punch).not_to be_valid
    end

    describe "employee associations" do
      it "is valid when time_punch with an employee" do
        punch = build(:time_punch, employee: employee, kind: :clock_in, punched_at: Time.current)
        expect(punch).to be_valid
      end

      it "is invalid when time_punch without an employee" do
        punch = build(:time_punch, employee: nil, kind: :clock_in, punched_at: Time.current)
        expect(punch).not_to be_valid
      end

      it "belongs to employee" do
        punch = create(:time_punch, employee: employee)
        expect(punch.employee).to eq(employee)
      end
    end

    describe "scopes" do
      it "is valid when clock_in returns only clock_in punches" do
        clock_in = create(:time_punch, employee: employee, kind: :clock_in, punched_at: 1.hour.ago)
        clock_out = create(:time_punch, employee: employee, kind: :clock_out, punched_at: Time.current)

        expect(TimePunch.clock_in).to include(clock_in)
        expect(TimePunch.clock_in).not_to include(clock_out)
      end

      it "is valid when clock_out returns only clock_out punches" do
        clock_in = create(:time_punch, employee: employee, kind: :clock_in, punched_at: 1.hour.ago)
        clock_out = create(:time_punch, employee: employee, kind: :clock_out, punched_at: Time.current)
        expect(TimePunch.clock_out).to include(clock_out)
        expect(TimePunch.clock_out).not_to include(clock_in)
      end
    end
  end
end
