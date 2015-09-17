require 'spec_helper'

describe Video do
  it { should belong_to(:category) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }
  it { should have_many(:reviews).order('created_at DESC') }

  describe "search_by_title" do
    it "returns an empty array if there is no match" do
      goodfellas = Video.create(title: 'Goodfellas', description: 'mafia kids in NYC.')
      casino = Video.create(title: 'Casino', description: 'mafia in Las Vegas.')
      expect(Video.search_by_title("hello")).to eq([])
    end

    it "returns an array of one video for an exact match" do
      goodfellas = Video.create(title: 'Goodfellas', description: 'mafia kids in NYC.')
      casino = Video.create(title: 'Casino', description: 'mafia in Las Vegas.')
      expect(Video.search_by_title("Casino")).to eq([casino])
    end

    it "returns an array of one vide for a partial match" do
      goodfellas = Video.create(title: 'Goodfellas', description: 'mafia kids in NYC.')
      casino = Video.create(title: 'Casino', description: 'mafia in Las Vegas.')
      expect(Video.search_by_title("sino")).to eq([casino])
    end

    it "returns an array of all matches ordered by created_at" do
      back_to_future = Video.create(title: 'Back to Future', description: 'time travel.', created_at: 1.day.ago)
      futurama = Video.create(title: 'Futurama', description: 'Time travel!')
      expect(Video.search_by_title("Futur")).to eq([futurama, back_to_future])
    end

    it "returns an empty array for a search with an empty string" do
      goodfellas = Video.create(title: 'Goodfellas', description: 'mafia kids in NYC.')
      casino = Video.create(title: 'Casino', description: 'mafia in Las Vegas.')
      expect(Video.search_by_title("")).to eq([])
    end
  end
end
