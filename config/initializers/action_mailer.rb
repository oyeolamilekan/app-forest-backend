require 'sib-api-v3-sdk'
require 'brevo_mailer'

ActionMailer::Base.add_delivery_method :brevo, BrevoMailer