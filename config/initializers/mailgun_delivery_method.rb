require "mailgun"

class MailgunDeliveryMethod
  def initialize(settings = {})
    @settings = settings
  end

  def deliver!(mail)
    api_key = @settings[:api_key] || ENV["MAILGUN_API_KEY"]
    domain  = @settings[:domain]  || ENV["MAILGUN_DOMAIN"]

    raise "MAILGUN_API_KEY não configurado" if api_key.blank?
    raise "MAILGUN_DOMAIN não configurado" if domain.blank?

    client = Mailgun::Client.new(api_key)
    message = Mailgun::MessageBuilder.new

    message.from(mail[:from].to_s)
    Array(mail.to).each { |to| message.add_recipient(:to, to) }
    message.subject(mail.subject)

    if mail.multipart?
      message.body_html(mail.html_part&.body&.decoded)
      message.body_text(mail.text_part&.body&.decoded)
    elsif mail.content_type&.include?("html")
      message.body_html(mail.body.decoded)
    else
      message.body_text(mail.body.decoded)
    end

    client.send_message(domain, message)
  end
end

ActionMailer::Base.add_delivery_method :mailgun, MailgunDeliveryMethod