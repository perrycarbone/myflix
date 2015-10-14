class AppMailer < ActionMailer::Base
  def send_welcome_email(user)
    @user = user
    mail to: user.email_address, from: "info@myflix.com", subject: "Welcome to MyFlix!"
  end
end
