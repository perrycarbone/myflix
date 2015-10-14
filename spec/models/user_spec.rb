require 'spec_helper'

describe User do
  it { should validate_presence_of(:email_address) }
  it { should validate_presence_of(:password) }
  it { should validate_presence_of(:full_name) }
  it { should validate_uniqueness_of(:email_address) }
  it { should have_many(:queue_items).order('position') }
  it { should have_many(:reviews).order('created_at DESC') }

  it "generates a random token when the user is created" do
    bob = Fabricate(:user)
    expect(bob.token).to be_present
  end

  describe "#queued_video?" do
    it "returns true when the user has the video queued in their queue" do
      user = Fabricate(:user)
      video = Fabricate(:video)
      queue_item = Fabricate(:queue_item, user: user, video: video)
      expect(user.queued_video?(video)).to be_truthy
    end

    it "returns false when the user does not have the video queued in their queue" do
      user = Fabricate(:user)
      video = Fabricate(:video)
      expect(user.queued_video?(video)).to be_falsey
    end
  end
end

describe "#follows?" do
  it "returns true if the user has a following relationship with another user" do
    bob = Fabricate(:user)
    jane = Fabricate(:user)
    Fabricate(:relationship, leader: jane, follower: bob)
    expect(bob.follows?(jane)).to be_truthy
  end

  it "returns false if the user does not have a following relationship with another user" do
    bob = Fabricate(:user)
    jane = Fabricate(:user)
    Fabricate(:relationship, leader: bob, follower: jane)
    expect(bob.follows?(jane)).to be_falsey
  end
end
