class UserMailer < ApplicationMailer
  def welcome_email(user)
    @full_name = "#{user.first_name} #{user.last_name}"
    @url  = "#{ENV['BASE_URL']}login"
    mail(to: user.email, subject: 'Welcome to Appstate')
  end
end
