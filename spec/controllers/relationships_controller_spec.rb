require 'spec_helper'

describe RelationshipsController do
  describe "GET index" do
    it "sets @relationships to the current user's following relationships" do
      bob = Fabricate(:user)
      set_current_user(bob)
      jane = Fabricate(:user)
      relationship = Fabricate(:relationship, follower: bob, leader: jane)
      get :index
      expect(assigns(:relationships)).to eq([relationship])
    end

    it_behaves_like "requires sign in" do
      let(:action) { get :index }
    end
  end

  describe "DELETE destroy" do
    it_behaves_like "requires sign in" do
      let(:action) { delete :destroy, id: 1 }
    end

    it "redirects to the people page" do
      bob = Fabricate(:user)
      set_current_user(bob)
      jane = Fabricate(:user)
      relationship = Fabricate(:relationship, follower: bob, leader: jane)
      delete :destroy, id: relationship
      expect(response).to redirect_to people_path
    end

    it "deletes the relationship if the current user is the follower" do
      bob = Fabricate(:user)
      set_current_user(bob)
      jane = Fabricate(:user)
      relationship = Fabricate(:relationship, follower: bob, leader: jane)
      delete :destroy, id: relationship
      expect(Relationship.count).to eq(0)
    end

    it "does not delete the relationship if the current user is not the follower" do
      bob = Fabricate(:user)
      set_current_user(bob)
      jane = Fabricate(:user)
      sam = Fabricate(:user)
      relationship = Fabricate(:relationship, follower: sam, leader: jane)
      delete :destroy, id: relationship
      expect(Relationship.count).to eq(1)
    end
  end

  describe "POST create" do
    it_behaves_like "requires sign in" do
      let(:action) { post :create, leader_id: 1 }
    end

    it "redirects to the people page" do
      bob = Fabricate(:user)
      jane = Fabricate(:user)
      set_current_user(bob)
      post :create, leader_id: jane.id
      expect(response).to redirect_to people_path
    end

    it "creates a relationship that the current user follows the leader" do
      bob = Fabricate(:user)
      jane = Fabricate(:user)
      set_current_user(bob)
      post :create, leader_id: jane.id
      expect(bob.following_relationships.first.leader).to eq(jane)
    end

    it "does not create a relationship if the current user already follows the leader" do
      bob = Fabricate(:user)
      jane = Fabricate(:user)
      set_current_user(bob)
      Fabricate(:relationship, follower: bob, leader: jane)
      post :create, leader_id: jane.id
      expect(Relationship.count).to eq(1)
    end

    it "does not allow one to follow themselves" do
      bob = Fabricate(:user)
      set_current_user(bob)
      post :create, leader_id: bob.id
      expect(Relationship.count).to eq(0)
    end
  end
end
