require 'spec_helper'

describe VideosController do
  describe "GET show" do
    it "sets @video for authenticated users" do
      session[:user_id] = Fabricate(:user).id
      video = Fabricate(:video)
      get :show, id: video.id
      expect(assigns(:video)).to eq(video)
    end

    it "redirects the user to sign in page if not authenticated" do
      video = Fabricate(:video)
      get :show, id: video.id
      expect(response).to redirect_to root_path
    end
  end

  describe "POST search" do
    it "sets results for authenticated users" do
      session[:user_id] = Fabricate(:user).id
      video = Fabricate(:video, title: 'video')
      post :search, search_term: "ideo"
      expect(assigns(:results)).to eq([video])
    end

    it "redirects to root_path for non-authenticated users" do
      video = Fabricate(:video, title: 'video')
      post :search, search_term: "ideo"
      expect(response).to redirect_to root_path
    end
  end
end
