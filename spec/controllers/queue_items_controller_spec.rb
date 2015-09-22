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

  describe "DELETE destroy" do
    it "redirects to the my queue page" do
      session[:user_id] = Fabricate(:user).id
      queue_item = Fabricate(:queue_item)
      delete :destroy, id: queue_item.id
      expect(response).to redirect_to my_queue_path
    end

    it "deletes the queue item" do
      bob = Fabricate(:user)
      session[:user_id] = bob.id
      queue_item = Fabricate(:queue_item, user: bob)
      delete :destroy, id: queue_item.id
      expect(QueueItem.count).to eq(0)
    end

    it "nomalizes the remaining queue items" do
      bob = Fabricate(:user)
      session[:user_id] = bob.id
      queue_item1 = Fabricate(:queue_item, user: bob, position: 1)
      queue_item2 = Fabricate(:queue_item, user: bob, position: 2)
      delete :destroy, id: queue_item1.id
      expect(QueueItem.first.position).to eq(1)
    end

    it "does not delete the queue item if the queue item is not in the current user's queue" do
      bob = Fabricate(:user)
      jane = Fabricate(:user)
      session[:user_id] = jane.id
      queue_item = Fabricate(:queue_item, user: bob)
      delete :destroy, id: queue_item.id
      expect(QueueItem.count).to eq(1)
    end

    it "redirects to login page for unauthenticated users" do
      delete :destroy, id: 10
      expect(response).to redirect_to login_path
    end
  end

  describe "POST queue_items" do
    context "with valid inputs" do

      let(:bob) { Fabricate(:user) }
      let(:video) { Fabricate(:video) }
      let(:queue_item1) { Fabricate(:queue_item, user: bob, position: 1, video: video) }
      let(:queue_item2) { Fabricate(:queue_item, user: bob, position: 2, video: video) }
      before { session[:user_id] = bob.id }

      it "redirects to the my_queue page" do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 2}, {id: queue_item2.id, position: 1}]
        expect(response).to redirect_to my_queue_path
      end

      it "reorders the queue items" do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 2}, {id: queue_item2.id, position: 1}]
        expect(bob.queue_items).to eq([queue_item2, queue_item1])
      end
      it "normalizes the position numbers" do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 3}, {id: queue_item2.id, position: 1}]
        expect(bob.queue_items.map(&:position)).to eq([1, 2])
      end
    end

    context "with invalid inputs" do

      let(:bob) { Fabricate(:user) }
      let(:video) { Fabricate(:video) }
      let(:queue_item1) { Fabricate(:queue_item, user: bob, position: 1, video: video) }
      let(:queue_item2) { Fabricate(:queue_item, user: bob, position: 2, video: video) }
      before { session[:user_id] = bob.id }

      it "redirects to the my_queue page" do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 3.8}, {id: queue_item2.id, position: 1}]
        expect(response).to redirect_to my_queue_path
      end

      it "sets flash error message" do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 3.8}, {id: queue_item2.id, position: 1}]
        expect(flash[:danger]).to be_present
      end

      it "does not change the queue items" do
        post :update_queue, queue_items: [{id: queue_item1.id, position: 3}, {id: queue_item2.id, position: 1.8}]
        expect(queue_item1.reload.position).to eq(1)
      end
    end

    context "with unauthenticated users" do
      it "redirects to the login path" do
        post :update_queue, queue_items: [{id: 1, position: 3}, {id: 4, position: 1}]
        expect(response).to redirect_to login_path
      end
    end

    context "with queue items that do not belong to current_user" do
      it "does not change the queue items" do
        jane = Fabricate(:user)
        session[:user_id] = jane.id
        bob = Fabricate(:user)
        video = Fabricate(:video)
        queue_item1 = Fabricate(:queue_item, user: bob, position: 1, video: video)
        queue_item2 = Fabricate(:queue_item, user: jane, position: 2, video: video)
        post :update_queue, queue_items: [{id: queue_item1.id, position: 2}, {id: queue_item2.id, position: 1}]
        expect(queue_item1.reload.position).to eq(1)
      end
    end
  end
end
