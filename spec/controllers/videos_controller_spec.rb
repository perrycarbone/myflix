require 'spec_helper'

describe VideosController do
  describe "GET show" do
    let(:video) { Fabricate(:video) }

    it "sets @video for authenticated users" do
      set_current_user
      get :show, id: video.token
      expect(assigns(:video)).to eq(video)
    end

    it "sets @reviews for authenticated users" do
      set_current_user
      review1 = Fabricate(:review, video: video)
      review2 = Fabricate(:review, video: video)
      get :show, id: video.token
      expect(assigns(:reviews)).to match_array([review1, review2])
    end

    it_behaves_like "requires sign in" do
      let(:action) { get :show, id: video.id }
    end
  end

  describe "POST search" do
    let(:video) { Fabricate(:video, title: 'video') }

    it "sets results for authenticated users" do
      set_current_user
      post :search, search_term: "ideo"
      expect(assigns(:results)).to eq([video])
    end

    it_behaves_like "requires sign in" do
      let(:action) { post :search, search_term: "ideo" }
    end
  end
end
