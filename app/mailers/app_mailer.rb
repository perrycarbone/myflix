class AppMailer < ActionMailer::Base
  default :from => "info@myflix.com"

  def send_welcome_email(user)
    @user = user
    mail to: user.email_address, subject: "Welcome to MyFlix!"
  end

  def send_forgot_password(user)
    @user = user
    mail to: user.email_address, subject: "Request to Reset Your MyFlix Password"
  end

  def send_invitation_email(invitation)
    @invitation = invitation
    mail to: invitation.recipient_email, from: "info@myflix.com", subject: "Invitation to Join MyFlix!"
  end
end
