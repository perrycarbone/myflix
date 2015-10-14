require 'spec_helper'

feature 'User following' do
  scenario "user follows and unfollows another user" do
    bob = Fabricate(:user)
    category = Fabricate(:category)
    video = Fabricate(:video, category: category)
    review = Fabricate(:review, user: bob, video: video)

    sign_in
    click_on_video_on_home_page(video)

    click_link bob.full_name
    click_link "Follow"
    expect(page).to have_content(bob.full_name)

    unfollow(bob)
    expect(page).not_to have_content(bob.full_name)
  end

  def unfollow(user)
    find('//html/body/section/section/table/tbody/tr/td[4]/a').click
  end
end
