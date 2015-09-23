require 'spec_helper'

feature "User logs in to application" do
  scenario "with correct email address and password" do
    bob = Fabricate(:user)
    visit login_path
    fill_in('Email Address', with: bob.email_address)
    fill_in('Password', with: bob.password)
    click_button 'Sign In'
    expect(page).to have_content 'You have successfully logged in.'
  end
end
