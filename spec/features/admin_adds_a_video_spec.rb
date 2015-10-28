require 'spec_helper'

feature 'Administrator adds a video' do
  scenario 'admin logs in and successfully adds video' do
    admin = Fabricate(:admin)
    drama = Fabricate(:category, name: 'Drama')

    sign_in(admin)
    visit new_admin_video_path

    admin_adds_video

    sign_out
    sign_in

    user_sees_video
  end

  def admin_adds_video
    fill_in 'Title', with: 'Goodfellas'
    select 'Drama', from: 'Category'
    fill_in 'Description', with: "Mafia movie!"
    attach_file 'Large cover', 'spec/support/uploads/goodfellas_large.jpg'
    attach_file 'Small cover', 'spec/support/uploads/goodfellas_small.jpg'
    fill_in 'Video URL', with: 'http://www.example.com/example_video.mp4'
    click_button 'Add Video'
  end

  def user_sees_video
    visit video_path(Video.first)
    expect(page).to have_selector("img[src='/uploads/goodfellas_large.jpg']")
    expect(page).to have_selector("a[href='http://www.example.com/example_video.mp4']")
  end
end
