class ForgotPasswordsController < ApplicationController
  def create
    user = User.find_by(email_address: params[:email])
    if user
      AppMailer.delay.send_forgot_password(user)
      redirect_to forgot_password_confirmation_path
    else
      flash[:danger] = params[:email].blank? ? "Please enter an email address" : "There is no user with that email address in the system."
      redirect_to forgot_password_path
    end
  end
end
