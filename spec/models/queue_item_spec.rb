require 'spec_helper'

describe QueueItem do
  it { should belong_to(:user) }
  it { should belong_to(:video) }

  describe "#video_title" do
    it "returns the title of the associated video" do
      video = Fabricate(:video, title: 'goodfellas')
      queue_item = Fabricate(:queue_item, video: video)
      expect(queue_item.video_title).to eq('goodfellas')
    end
  end
  
  describe "#rating" do
    let(:video) { Fabricate(:video) }
    let(:user) { Fabricate(:user) }
    let(:queue_item) { Fabricate(:queue_item, user: user, video: video) }
    
    it "returns the rating from the review when the review is present" do
      review = Fabricate(:review, user: user, video: video, rating: 5)
      expect(queue_item.rating).to eq(5)
    end
    
    it "returns nil when the review is not present" do
      expect(queue_item.rating).to be nil
    end
  end 

  describe "#category_name" do
    it "returns the categories' name of the video" do
      category = Fabricate(:category, name: 'drama')
      video = Fabricate(:video, category: category)
      queue_item = Fabricate(:queue_item, video: video)
      expect(queue_item.category_name).to eq('drama')
    end
  end

  describe "#category" do
    it "returns the category of the video" do
      category = Fabricate(:category, name: 'drama')
      video = Fabricate(:video, category: category)
      queue_item = Fabricate(:queue_item, video: video)
      expect(queue_item.category).to eq(category)
    end
  end
end
