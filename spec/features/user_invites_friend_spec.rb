require 'spec_helper'
require 'capybara/email/rspec'

feature 'User invites friend' do
  scenario 'User successfully invites friend and invitation is accepted' do
    bob = Fabricate(:user)
    sign_in(bob)

    invite_a_friend
    friend_accepts_invitation
    friend_signs_in

    friend_should_follow(bob)
    inviter_should_follow(bob)

    clear_email
  end

  def invite_a_friend
    visit new_invitation_path
    fill_in "Friend's Name", with: "John Doe"
    fill_in "Friend's Email Address", with: "john@example.com"
    fill_in "Message", with: "Please join this site!"
    click_button "Send Invitation"
    sign_out
  end

  def friend_accepts_invitation
    open_email "john@example.com"
    current_email.click_link "Accept this Invitation"
    fill_in "Password", with: 'password'
    fill_in "Full Name", with: 'John Doe'
    click_button "Sign Up"
  end

  def friend_signs_in
    fill_in "Email Address", with: 'john@example.com'
    fill_in "Password", with: 'password'
    click_button "Sign In"
  end

  def friend_should_follow(user)
    click_link "People"
    expect(page).to have_content user.full_name
    sign_out
  end

  def inviter_should_follow(user)
    sign_in(user)
    click_link "People"
    expect(page).to have_content "John Doe"
  end
end
