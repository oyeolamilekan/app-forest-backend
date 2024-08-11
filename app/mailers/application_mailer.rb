class ApplicationMailer < ActionMailer::Base
  default from: email_address_with_name("system@withapp.xyz", "Appstate")
  default 'X-MC-AutoText' => 1
  default 'Reply-To' => email_address_with_name("system@withapp.xyz", "Appstate")
  layout "mailer"
end
