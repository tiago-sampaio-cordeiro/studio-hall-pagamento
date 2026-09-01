require 'net/http'

module Notification
  class PunchNotifier
    TOPIC = "studiohall-notificacoes"

    def initialize(employee:, punch:)
      @employee = employee
      @punch = punch
    end

    def call
      notify
    end

    private

    attr_reader :employee, :punch

    def notify
      uri = URI("https://ntfy.sh/#{TOPIC}")
      message = "#{employee.user.first_name} registrou #{punch.kind} às #{punch.punched_at.strftime("%H:%M")} de #{punch.punched_at.strftime("%d/%m/%Y")}"
      Net::HTTP.post(uri, message)
    end
  end
end