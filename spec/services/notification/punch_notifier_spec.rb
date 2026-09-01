require 'rails_helper'

RSpec.describe Notification::PunchNotifier, type: :service do
  let(:employee) { create(:employee) }
  let(:punch) { create(:time_punch, employee: employee, kind: :clock_in, punched_at: "2026-01-01 08:00:00") }

  describe "#call" do
    it "sends notification to correct url" do
      expect(Net::HTTP).to receive(:post)
      Notification::PunchNotifier.new(employee: employee, punch: punch).call
    end

    it "mounts message correctly with employee data" do
      allow(Net::HTTP).to receive(:post)

      Notification::PunchNotifier.new(employee: employee, punch: punch).call

      expect(Net::HTTP).to have_received(:post).with(
        URI("https://ntfy.sh/studiohall-notificacoes"),
        "#{employee.user.first_name} registrou clock_in às 08:00 de 01/01/2026"
      )
    end
  end
end