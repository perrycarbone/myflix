require 'spec_helper'

describe ForgotPasswordsController do
  describe "POST create" do
    context "with blank input" do
      before { post :create, email: '' }

      it "redirects to the forgot password page" do
        expect(response).to redirect_to forgot_password_path
      end

      it "shows an error message" do
        expect(flash[:danger]).to eq("Please enter an email address")
      end
    end

    context "with existing email" do
      before { Fabricate(:user, email_address: 'joe@example.com') }
      before { post :create, email: 'joe@example.com' }

      it "should redirect to the forgot password confirmation page" do
        expect(response).to redirect_to forgot_password_confirmation_path
      end

      it "should send out an email to the email address" do
        expect(ActionMailer::Base.deliveries.last.to).to eq(['joe@example.com'])
      end
    end

    context "with non-existing email" do
      before { post :create, email: 'bob@example.com' }
      it "redirects to the forgot password page" do
        expect(response).to redirect_to forgot_password_path
      end

      it "show an error message" do
        expect(flash[:danger]).to eq("There is no user with that email address in the system.")
      end
    end
  end
end
