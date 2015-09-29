require 'spec_helper'

feature "User logs in to application" do
  scenario "with correct email address and password" do
    bob = Fabricate(:user) 
    sign_in(bob)
    expect(page).to have_content 'You have successfully logged in.'
  end
end
