require 'spec_helper'

describe InvitationsController do
  describe "GET new" do
    it "sets @invitation to a new invitation" do
      set_current_user
      get :new
      expect(assigns(:invitation)).to be_a_new(Invitation)
    end

    it_behaves_like "requires sign in" do
      let(:action) { get :new }
    end
  end

  describe "POST create" do
    it_behaves_like "requires sign in" do
      let(:action) { post :create }
    end

    context "with valid input" do
      before do
        ActionMailer::Base.deliveries.clear
        set_current_user
        post :create, invitation: { recipient_name: "John Doe", recipient_email: "john@example.com", message: "Hello there!" }
      end

      it "redirects to the invitation new page" do
        expect(response).to redirect_to(new_invitation_path)
      end

      it "creates an invitation" do
        expect(Invitation.count).to eq(1)
      end

      it "sends an email to the recipient" do
        expect(ActionMailer::Base.deliveries.last.to).to eq(["john@example.com"])
      end

      it "sets the flash success message" do
        expect(flash[:success]).to be_present
      end
    end

    context "with invalid input" do
      before do
        ActionMailer::Base.deliveries.clear
        set_current_user
        post :create, invitation: { recipient_name: "John Doe" }
      end

      it "renders the :new template" do
        expect(response).to render_template :new
      end

      it "does not create an invitation" do
        expect(Invitation.count).to be(0)
      end

      it "does not send out an email" do
        expect(ActionMailer::Base.deliveries).to be_empty
      end

      it "sets the flash error message" do
        expect(flash[:danger]).to be_present
      end

      it "sets @invitation" do
        expect(assigns(:invitation)).to be_a_new(Invitation)
      end
    end
  end
end
