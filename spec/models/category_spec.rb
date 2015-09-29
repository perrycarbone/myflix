require 'spec_helper'

describe Category do
  it { should have_many(:videos) }
  it { should validate_presence_of(:name) }

  describe "#recent_videos" do
    let(:drama) { Fabricate(:category, name: "drama") }

    it "returns the videos in reverse chronological order by created_at" do
      video1 = Video.create(title: "Video 1", description: "Some description", category: drama, created_at: 1.day.ago)
      video2 = Video.create(title: "Video 2", description: "Some description", category: drama)
      expect(drama.recent_videos).to eq([video2, video1])
    end

    it "returns all videos if there are less than six videos" do
      video1 = Video.create(title: "Video 1", description: "Some description", category: drama, created_at: 1.day.ago)
      video2 = Video.create(title: "Video 2", description: "Some description", category: drama)
      expect(drama.recent_videos.count).to eq(2)
    end

    it "returns only six videos if there are more than six videos in category" do
      7.times  { Video.create(title: "something", description: "something", category: drama) }
      expect(drama.recent_videos.count).to eq(6)
    end

    it "returns most recent six videos" do
      6.times  { Video.create(title: "something", description: "something", category: drama) }
      oldest_video = Video.create(title: "old show", description: "something", category: drama, created_at: 1.day.ago)
      expect(drama.recent_videos).not_to include(oldest_video)
    end

    it "returns empty array if category does not have any videos" do
      expect(drama.recent_videos).to eq([])
    end
  end
end
