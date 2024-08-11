class UserMailer < ApplicationMailer
  def welcome_email(user)
    @full_name = "hhhh"
    @url  = "#{ENV['BASE_URL']}login"
    mail(to: "johnsonoye34@gmail.com", subject: 'Welcome to Appstate')
  end
end
