require 'spec_helper'

feature "User interacts with queue" do
  scenario "user adds and reorders video in the queue" do
    drama = Fabricate(:category)
    goodfellas = Fabricate(:video, title: 'Goodfellas', category: drama)
    the_godfather = Fabricate(:video, title: 'The Godfather', category: drama)
    donnie_brasco = Fabricate(:video, title: 'Donnie Brasco', category: drama)

    sign_in

    add_video_to_queue(goodfellas)
    expect_video_to_be_in_queue(goodfellas)

    visit video_path(goodfellas)
    expect_link_to_be_seen("+ My Queue")

    add_video_to_queue(the_godfather)
    add_video_to_queue(donnie_brasco)

    set_video_position(goodfellas, 3)
    set_video_position(the_godfather, 1)
    set_video_position(donnie_brasco, 2)
    update_queue

    expect_video_position(the_godfather, 1)
    expect_video_position(goodfellas, 3)
    expect_video_position(donnie_brasco, 2)
  end

  def expect_video_to_be_in_queue(video)
    expect(page).to have_content(video.title)
  end

  def expect_link_to_be_seen(link_text)
    expect(page).to have_no_content "#{link_text}"
  end

  def add_video_to_queue(video)
    visit home_path
    find("a[href='/videos/#{video.token}']").click
    click_link "+ My Queue"
  end

  def set_video_position(video_title, position)
    find("input[data-video-id='#{video_title.id}']").set(position)
  end

  def update_queue
    click_button "Update Instant Queue"
  end

  def expect_video_position(video_title, position)
    expect(find("input[data-video-id='#{video_title.id}']").value).to eq("#{position}")
  end
end
