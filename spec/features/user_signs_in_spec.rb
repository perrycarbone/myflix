require 'spec_helper'

feature "User logs in to application" do
  scenario "with correct email address and password" do
    bob = Fabricate(:user)
    sign_in(bob)
    expect(page).to have_content 'You have successfully logged in.'
  end

  scenario "with deactivated card" do
    bob = Fabricate(:user, active: false)
    sign_in(bob)
    expect(page).not_to have_content 'You have successfully logged in.'
    expect(page).to have_content 'Your account has been suspended.  Please contact customer service.'
  end
end
