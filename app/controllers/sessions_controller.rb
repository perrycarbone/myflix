class SessionsController < ApplicationController

  def create
    user = User.where(email_address: params[:email_address]).first
      if user && user.authenticate(params[:password])
        login_success!(user)
      else
        flash[:danger] = "Your Username or Password is incorrect."
        redirect_to login_path
      end
  end

  def destroy
    session[:user_id] = nil
    flash[:info] = "You have logged out."
    redirect_to root_path
  end

  private
  def login_success!(user)
    session[:user_id] = user.id
    flash[:success] = "You have successfully logged in."
    redirect_to videos_path
  end

end
