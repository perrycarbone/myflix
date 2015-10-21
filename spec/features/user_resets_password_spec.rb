require 'spec_helper'
require 'capybara/email/rspec'

feature 'User resets password' do
  scenario 'User successfully resets password' do
    clear_email
    bob = Fabricate(:user, password: 'old_password')
    visit login_path
    click_link 'Forgot Password?'
    fill_in 'Email Address:', with: bob.email_address
    click_button 'Submit'

    open_email(bob.email_address)
    current_email.click_link('Reset My Password')

    fill_in 'New Password', with: 'new_password'
    click_button 'Reset Password'

    fill_in 'Email Address', with: bob.email_address
    fill_in 'Password', with: 'new_password'
    click_button 'Sign In'

    expect(page).to have_content('You have successfully logged in.')
  end
end
