require 'spec_helper'

describe VideosController do
  describe "GET show" do
    let(:video) { Fabricate(:video) }
    
    it "sets @video for authenticated users" do
      session[:user_id] = Fabricate(:user).id
      get :show, id: video.id
      expect(assigns(:video)).to eq(video)
    end

    it "sets @reviews for authenticated users" do
      session[:user_id] = Fabricate(:user).id
      review1 = Fabricate(:review, video: video)
      review2 = Fabricate(:review, video: video)
      get :show, id: video.id
      expect(assigns(:reviews)).to match_array([review1, review2])
    end

    it "redirects the user to sign in page if not authenticated" do
      get :show, id: video.id
      expect(response).to redirect_to login_path
    end
  end

  describe "POST search" do
    let(:video) { Fabricate(:video, title: 'video') }

    it "sets results for authenticated users" do
      session[:user_id] = Fabricate(:user).id
      post :search, search_term: "ideo"
      expect(assigns(:results)).to eq([video])
    end

    it "redirects to sign in page for non-authenticated users" do
      post :search, search_term: "ideo"
      expect(response).to redirect_to login_path
    end
  end
end
