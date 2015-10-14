class PasswordResetsController < ApplicationController
  def show
    user = User.find_by(token: params[:id])
    redirect_to expired_token_path unless user
  end

end
