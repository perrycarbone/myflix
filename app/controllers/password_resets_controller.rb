class PasswordResetsController < ApplicationController
  def show
    user = User.find_by(token: params[:id])
    if user
      @token = user.token
    else
      redirect_to expired_token_path unless user
    end
  end

  def create
    user = User.find_by(token: params[:token])
    if user
      user.update(password: params[:password])
      user.generate_token
      user.save
      flash[:success] = "Your password has been updated."
      redirect_to login_path
    else
      redirect_to expired_token_path
    end
  end
end
