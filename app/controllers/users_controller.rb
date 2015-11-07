class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :update]
  before_action :require_user, except: [:new, :create, :front, :new_with_invitation_token]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      handle_invitation
      handle_charge
      AppMailer.delay.send_welcome_email(@user)
      flash[:success] = "You are registered.  Please sign in."
      redirect_to login_path
    else
      render :new
    end
  end

  def show
    @user = User.find_by(id: params[:id])
  end

  def edit; end

  def update
    if @user.update(user_params)
      flash[:success] = "Your information has been updated."
      redirect_to user_path
    else
      render :edit
    end
  end

  def front; end

  def new_with_invitation_token
    invitation = Invitation.find_by(token: params[:token])
    if invitation
      @user = User.new(email_address: invitation.recipient_email)
      @invitation_token = invitation.token
      render :new
    else
      redirect_to expired_token_path
    end
  end

  private

  def user_params
    params.require(:user).permit(:email_address, :password, :full_name)
  end

  def set_user
    @user = User.find_by(params[:user_id])
  end

  def handle_invitation
    if params[:invitation_token].present?
      invitation = Invitation.find_by(token: params[:invitation_token])
      @user.follow(invitation.inviter)
      invitation.inviter.follow(@user)
      invitation.update_column(:token, nil)
    end
  end

  def handle_charge
    Stripe.api_key = ENV['STRIPE_SECRET_KEY']
    Stripe::Charge.create(
          :amount => 999,
          :currency => "usd",
          :source => params[:stripeToken],
          :description => "$9.99 sign up charge for #{@user.email_address}"
        )
  end
end
