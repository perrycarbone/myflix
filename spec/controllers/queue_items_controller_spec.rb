require 'spec_helper'

describe QueueItemsController do
  describe "GET index" do
    it "sets @queue_items to the queue items of the logged in user" do
      bob = Fabricate(:user)
      session[:user_id] = bob.id
      queue_item1 = Fabricate(:queue_item, user: bob)
      queue_item2 = Fabricate(:queue_item, user: bob)
      get :index
      expect(assigns(:queue_items)).to match_array([queue_item1, queue_item2])
    end

    it "redirects to login page for unauthenticated users" do
      get :index
      expect(response).to redirect_to login_path
    end
  end

  describe "POST create" do
    let(:bob) { Fabricate(:user) }
    let(:video) { Fabricate(:video) }

    it "redirects to my_queue page" do
      session[:user_id] = Fabricate(:user).id
      post :create, video_id: video.id
      expect(response).to redirect_to my_queue_path
    end

    it "creates a queue item" do
      session[:user_id] = Fabricate(:user).id
      post :create, video_id: video.id
      expect(QueueItem.count).to eq(1)
    end

    it "creates the queue item that is associated with the video" do
      session[:user_id] = Fabricate(:user).id
      post :create, video_id: video.id
      expect(QueueItem.first.video).to eq(video)
    end

    it "creates the queue item that is associated with the signed in user" do
      session[:user_id] = bob.id
      post :create, video_id: video.id
      expect(QueueItem.first.user).to eq(bob)
    end

    it "makes the video the last video in the queue" do
      session[:user_id] = bob.id
      goodfellas = Fabricate(:video)
      Fabricate(:queue_item, video: goodfellas, user: bob)
      godfather = Fabricate(:video)
      post :create, video_id: godfather.id
      godfather_queue_item = QueueItem.find_by(video_id: godfather.id, user_id: bob.id)
      expect(godfather_queue_item.position).to eq(2)
    end
    it "does not add the video to the queue if the video is already in the queue" do
      session[:user_id] = bob.id
      goodfellas = Fabricate(:video)
      Fabricate(:queue_item, video: goodfellas, user: bob)
      post :create, video_id: goodfellas.id
      expect(bob.queue_items.count).to eq(1)
    end

    it "redirects to the login page for unauthenticated users" do
      post :create, video_id: 3
      expect(response).to redirect_to login_path
    end  
  end
end
