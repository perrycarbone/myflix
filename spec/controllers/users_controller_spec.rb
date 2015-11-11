require 'spec_helper'

describe UsersController do
  describe "GET new" do
    it "sets @user" do
      get :new
      expect(assigns(:user)).to be_instance_of(User)
    end
  end

  # describe "POST create" do
  #   context "with valid input" do
  #     before do
  #       post :create, user: Fabricate.attributes_for(:user)
  #     end
  #
  #     it "creates the user" do
  #       expect(User.count).to eq(1)
  #     end
  #
  #     it "redirects to sign in page" do
  #       expect(response).to redirect_to login_path
  #     end
  #
  #     it "makes the user follow the inviter" do
  #       bob = Fabricate(:user)
  #       invitation = Fabricate(:invitation, inviter: bob, recipient_email: 'jane@example.com')
  #       post :create, user: {email_address: 'jane@example.com', password: 'password', full_name: 'Jane Doe'}, invitation_token: invitation.token
  #       jane = User.find_by(email_address: 'jane@example.com')
  #       expect(jane.follows?(bob)).to be_truthy
  #     end
  #
  #     it "makes the inviter follow the user" do
  #       bob = Fabricate(:user)
  #       invitation = Fabricate(:invitation, inviter: bob, recipient_email: 'jane@example.com')
  #       post :create, user: {email_address: 'jane@example.com', password: 'password', full_name: 'Jane Doe'}, invitation_token: invitation.token
  #       jane = User.find_by(email_address: 'jane@example.com')
  #       expect(bob.follows?(jane)).to be_truthy
  #     end
  #
  #     it "expires the invitation upon acceptance" do
  #       bob = Fabricate(:user)
  #       invitation = Fabricate(:invitation, inviter: bob, recipient_email: 'jane@example.com')
  #       post :create, user: {email_address: 'jane@example.com', password: 'password', full_name: 'Jane Doe'}, invitation_token: invitation.token
  #       jane = User.find_by(email_address: 'jane@example.com')
  #       expect(Invitation.first.token).to be_nil
  #     end
  #   end

    context "with invalid input" do
      before do
        post :create, user: { password: "password", full_name: "Perry Carbone" }
      end

      it "does not create the user" do
        expect(User.count).to eq(0)
      end

      it "render the :new template" do
        expect(response).to render_template :new
      end

      it "sets @user" do
        expect(assigns(:user)).to be_instance_of(User)
      end
    end

    context "test email sending" do

      before { ActionMailer::Base.deliveries.clear }

      # it "sends out email to the user valid inputs" do
      #   post :create, user: { email_address: "jane@example.com", password: "password", full_name: "Jane Doe" }
      #   expect(ActionMailer::Base.deliveries.last.to).to eq(['jane@example.com'])
      # end
      #
      # it "sends out email containing the users name with valid inputs" do
      #   post :create, user: { email_address: "jane@example.com", password: "password", full_name: "Jane Doe" }
      #   expect(ActionMailer::Base.deliveries.last.body).to include("Jane Doe")
      # end

      it "does not send out email with invalid inputs" do
        post :create, user: { email_address: "jane@example.com", password: "password" }
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    # end
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
