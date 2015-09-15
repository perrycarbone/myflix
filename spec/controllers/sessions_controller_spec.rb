require 'spec_helper'

describe SessionsController do
  describe "GET new" do
    it "renders the :new template for unauthenticated users" do
      get :new
      expect(response).to render_template :new    
    end
    it "redirects to the videos page for authenticated user" do
      session[:user_id] = Fabricate(:user).id
      get :new
      expect(response).to redirect_to home_path
    end
  end

  describe "POST create" do
    context "with valid credentials" do
      let(:bob) { Fabricate(:user) }
      before { post :create, email_address: bob.email_address, password: bob.password }
          
      it "puts signed-in user into session" do  
        expect(session[:user_id]).to eq(bob.id)
      end

      it "redirects to home_path" do
        expect(response).to redirect_to home_path
      end

      it "sets login notice" do
        expect(flash[:success]).not_to be_blank
      end
    end

    context "with invalid credentials" do
      let(:bob) { Fabricate(:user) }
      before { post :create, email_address: bob.email_address, password: bob.password + "skdjfsdkjb" }

      it "does not put user into session" do        
        expect(session[:user_id]).to be_nil
      end

      it "redirects to login page" do
        expect(response).to redirect_to login_path
      end

      it "sets the error message" do
        expect(flash[:danger]).not_to be_blank
      end
    end
  end

  describe "GET destroy" do
    before do
      session[:user_id] = Fabricate(:user).id
      get :destroy
    end

    it "clears the sessions from the user" do
      expect(session[:user_id]).to be_nil
    end

    it "sets the logout notice" do
      expect(flash[:info]).not_to be_blank
    end

    it "redirects to root path" do
      expect(response).to redirect_to root_path      
    end
  end

end
