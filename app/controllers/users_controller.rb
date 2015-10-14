class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :update]
  before_action :require_user, except: [:new, :create, :front]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      AppMailer.send_welcome_email(@user).deliver
      flash[:success] = "You are registered.  Please sign in."
      redirect_to login_path
    else
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
  end

  def update
    if @user.update(user_params)
      flash[:success] = "Your information has been updated."
      redirect_to user_path
    else
      render :edit
    end
  end

  def front
  end

  private

  def user_params
    params.require(:user).permit(:email_address, :password, :full_name)
  end

  def set_user
    @user = User.where(params[:user_id])
  end
end
