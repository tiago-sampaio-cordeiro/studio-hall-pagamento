class ApplicationMailer < ActionMailer::Base
  default from: "Studio Hall <no-reply@#{ENV["MAILGUN_DOMAIN"]}>"
  layout "mailer"
end
