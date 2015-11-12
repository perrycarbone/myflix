require 'spec_helper'

describe Video do
  it { should belong_to(:category) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }
  it { should have_many(:reviews).order('created_at DESC') }

  it_behaves_like "tokenable" do
    let(:object) { Fabricate(:user) }
  end

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

  describe ".search", :elasticsearch do
  let(:refresh_index) do
    Video.import
    Video.__elasticsearch__.refresh_index!
  end

    context "with title" do
      it "returns no results when there's no match" do
        Fabricate(:video, title: "Futurama")
        refresh_index

        expect(Video.search("whatever").records.to_a).to eq []
      end

      it "returns an empty array when there's no search term" do
        futurama = Fabricate(:video)
        south_park = Fabricate(:video)
        refresh_index

        expect(Video.search("").records.to_a).to eq []
      end

      it "returns an array of 1 video for title case insensitve match" do
        futurama = Fabricate(:video, title: "Futurama")
        south_park = Fabricate(:video, title: "South Park")
        refresh_index

        expect(Video.search("futurama").records.to_a).to eq [futurama]
      end

      it "returns an array of many videos for title match" do
        star_trek = Fabricate(:video, title: "Star Trek")
        star_wars = Fabricate(:video, title: "Star Wars")
        refresh_index

        expect(Video.search("star").records.to_a).to match_array [star_trek, star_wars]
      end
    end

    context "with title and description" do
      it "returns an array of many videos based for title and description match" do
        star_wars = Fabricate(:video, title: "Star Wars")
        about_sun = Fabricate(:video, description: "sun is a star")
        refresh_index

        expect(Video.search("star").records.to_a).to match_array [star_wars, about_sun]
      end
    end

    context "multiple words must match" do
      it "returns an array of videos where 2 words match title" do
        star_wars_1 = Fabricate(:video, title: "Star Wars: Episode 1")
        star_wars_2 = Fabricate(:video, title: "Star Wars: Episode 2")
        bride_wars = Fabricate(:video, title: "Bride Wars")
        star_trek = Fabricate(:video, title: "Star Trek")
        refresh_index

        expect(Video.search("Star Wars").records.to_a).to match_array [star_wars_1, star_wars_2]
      end
    end
  end
end
