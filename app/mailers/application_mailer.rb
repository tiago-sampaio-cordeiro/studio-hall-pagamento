class ApplicationMailer < ActionMailer::Base
  default from: ENV["MAILGUN_DOMAIN"]
  layout "mailer"
end
