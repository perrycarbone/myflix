class AdminsController < ApplicationController

  private

  def require_admin
    if !current_user.admin?
      flash[:danger] = "You do not have permission to do that."
      redirect_to home_path
    end
  end
end
