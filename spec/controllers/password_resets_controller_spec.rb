require 'spec_helper'

describe PasswordResetsController do
  describe "GET show" do
    it "renders the show template if the token is valid" do
      bob = Fabricate(:user)
      bob.update_column(:token, '12345')
      get :show, id: 12345
      expect(response).to render_template :show
    end

    it "sets @token" do
      bob = Fabricate(:user)
      bob.update_column(:token, '12345')
      get :show, id: 12345
      expect(assigns(:token)).to eq('12345')
    end


    it "redirects to the expired token page if the token is not valid" do
      get :show, id: 12345
      expect(response).to redirect_to expired_token_path
    end
  end

  describe "POST create" do
    context "with valid token" do
      it "redirects user to the sign in page" do
        bob = Fabricate(:user, password: 'old password')
        bob.update_column(:token, '12345')
        post :create, token: '12345', password: 'new password'
        expect(response).to redirect_to login_path
      end

      it "updates the user's password" do
        bob = Fabricate(:user, password: 'old password')
        bob.update_column(:token, '12345')
        post :create, token: '12345', password: 'new password'
        expect(bob.reload.authenticate('new password')).to be_truthy
      end


      it "sets flash success message" do
        bob = Fabricate(:user, password: 'old password')
        bob.update_column(:token, '12345')
        post :create, token: '12345', password: 'new password'
        expect(flash[:success]).to be_present
      end

      it "regenerates the user's token" do
        bob = Fabricate(:user, password: 'old password')
        bob.update_column(:token, '12345')
        post :create, token: '12345', password: 'new password'
        expect(bob.reload.token).not_to eq('12345')
      end
    end

    context "with invalid token" do
      it "redirects to the expired token path" do
        post :create, token: '12345', password: 'some_password'
        expect(response).to redirect_to expired_token_path
      end
    end

  end
end
