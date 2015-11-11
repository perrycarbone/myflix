require 'spec_helper'

describe UsersController do
  describe "GET new" do
    it "sets @user" do
      get :new
      expect(assigns(:user)).to be_instance_of(User)
    end
  end

  describe "POST create" do
    context "successful user sign up" do

      it "redirects to sign in page" do
        result = double(:sign_up_result, successful?: true)
        UserSignup.any_instance.should_receive(:sign_up).and_return(result)
        post :create, user: Fabricate.attributes_for(:user)
        expect(response).to redirect_to login_path
      end
<<<<<<< HEAD
=======

      it "makes the user follow the inviter" do
        bob = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: bob, recipient_email: 'jane@example.com')
        post :create, user: {email_address: 'jane@example.com', password: 'password', full_name: 'Jane Doe'}, invitation_token: invitation.token
        jane = User.find_by(email_address: 'jane@example.com')
        expect(jane.follows?(bob)).to be_truthy
      end

      it "makes the inviter follow the user" do
        bob = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: bob, recipient_email: 'jane@example.com')
        post :create, user: {email_address: 'jane@example.com', password: 'password', full_name: 'Jane Doe'}, invitation_token: invitation.token
        jane = User.find_by(email_address: 'jane@example.com')
        expect(bob.follows?(jane)).to be_truthy
      end

      it "expires the invitation upon acceptance" do
        bob = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: bob, recipient_email: 'jane@example.com')
        post :create, user: {email_address: 'jane@example.com', password: 'password', full_name: 'Jane Doe'}, invitation_token: invitation.token
        expect(Invitation.first.token).to be_nil
      end
    end

    context "valid personal info and declined card" do
      it "renders the :new template" do
        charge = double(:charge, successful?: false, error_message: 'Your card was declined.')
        StripeWrapper::Charge.stub(:create).and_return(charge)
        post :create, user: Fabricate.attributes_for(:user), stripeToken: '123'
        expect(response).to render_template :new
      end

      it "does not create a new user record" do
        charge = double(:charge, successful?: false, error_message: 'Your card was declined.')
        StripeWrapper::Charge.stub(:create).and_return(charge)
        post :create, user: Fabricate.attributes_for(:user), stripeToken: '123'
        expect(User.count).to eq(0)
      end

      it "sets the flash error message" do
        charge = double(:charge, successful?: false, error_message: 'Your card was declined.')
        StripeWrapper::Charge.stub(:create).and_return(charge)
        post :create, user: Fabricate.attributes_for(:user), stripeToken: '123'
        expect(flash[:danger]).to be_present
      end
>>>>>>> mod13
    end

    context "failed user sign up" do
      before do
        result = double(:sign_up_result, successful?: false, error_message: 'This is an error message!')
        UserSignup.any_instance.should_receive(:sign_up).and_return(result)
        post :create, user: Fabricate.attributes_for(:user), stripeToken: '123'
      end
      it "renders the :new template" do
        expect(response).to render_template :new
      end

<<<<<<< HEAD
      it "sets the flash error message" do
        expect(flash[:danger]).to eq('This is an error message!')
=======
      it "sets @user" do
        expect(assigns(:user)).to be_instance_of(User)
      end

      it "does not charge the card" do
        expect(StripeWrapper::Charge).not_to receive(:create)
        post :create, user: {email_address: 'joe@example.com' }
      end
    end

    context "test email sending" do
      let(:charge) { double(:charge, successful?: true) }
      before do
        ActionMailer::Base.deliveries.clear
        StripeWrapper::Charge.stub(:create).and_return(charge)
      end

      it "sends out email to the user valid inputs" do
        post :create, user: { email_address: "jane@example.com", password: "password", full_name: "Jane Doe" }
        expect(ActionMailer::Base.deliveries.last.to).to eq(['jane@example.com'])
      end

      it "sends out email containing the users name with valid inputs" do
        post :create, user: { email_address: "jane@example.com", password: "password", full_name: "Jane Doe" }
        expect(ActionMailer::Base.deliveries.last.body).to include("Jane Doe")
      end

      it "does not send out email with invalid inputs" do
        post :create, user: { email_address: "jane@example.com", password: "password" }
        expect(ActionMailer::Base.deliveries).to be_empty
>>>>>>> mod13
      end
    end
  end

  describe "GET show" do
    it_behaves_like "requires sign in" do
      let(:action) { get :show, id: 1 }
    end

    it "sets the @user variable" do
      set_current_user
      bob = Fabricate(:user)
      get :show, id: bob.id
      expect(assigns(:user)).to eq(bob)
    end
  end

  describe "GET new_with_invitation_token" do
    it "renders the :new view template" do
      invitation = Fabricate(:invitation)
      get :new_with_invitation_token, token: invitation.token
      expect(response).to render_template :new
    end

    it "sets @user with recipient's email" do
      invitation = Fabricate(:invitation)
      get :new_with_invitation_token, token: invitation.token
      expect(assigns(:user).email_address).to eq(invitation.recipient_email)
    end

    it "sets @invitation_token" do
      invitation = Fabricate(:invitation)
      get :new_with_invitation_token, token: invitation.token
      expect(assigns(:invitation_token)).to eq(invitation.token)
    end

    it "redirects to expired token page for invalid token" do
      get :new_with_invitation_token, token: 'skdfj234'
      expect(response).to redirect_to expired_token_path
    end
  end
end
