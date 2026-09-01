require 'rails_helper'

RSpec.describe TimeClock::EmployeeTimeClock, type: :service do
  let(:employee) {create :employee}

  describe "punch" do
    it "created correctly" do
      register = TimeClock::EmployeeTimeClock.new(employee:employee,
                                                  kind: :clock_in,
                                                  punched_at: Time.current).call
      expect(register).to be_a(TimePunch)
    end

    it "created with kind correct" do
      register = TimeClock::EmployeeTimeClock.new(employee:employee,
                                                  kind: :clock_in,
                                                  punched_at: Time.current).call

      expect(register.kind).to eq("clock_in")
    end

    it "calls notifier after creating punch" do
      notifier = instance_double(Notification::PunchNotifier)
      allow(Notification::PunchNotifier).to receive(:new).and_return(notifier)
      allow(notifier).to receive(:call)

      TimeClock::EmployeeTimeClock.new(employee: employee, kind: :clock_in, punched_at: Time.current).call

      expect(notifier).to have_received(:call)
    end

  end
end