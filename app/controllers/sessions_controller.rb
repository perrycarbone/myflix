class SessionsController < ApplicationController
  def new
    redirect_to home_path if current_user
  end

  def create
    user = User.find_by(email_address: params[:email_address])
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
    redirect_to home_path
  end

end
