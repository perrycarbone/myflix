require 'spec_helper'

feature 'User registers', { js: true, vcr: true } do
  background do
    visit register_path
  end

  scenario 'with valid user info and valid credit card info' do
    fill_in_valid_user_info
    fill_in_valid_credit_card_info
    click_button "Sign Up"
    expect(page).to have_content 'You are registered.  Please sign in.'
  end

  scenario 'with valid user info and invalid card info' do
    fill_in_valid_user_info
    fill_in_invalid_credit_card_info
    click_button "Sign Up"
    expect(page).to have_content "Your card's security code is incorrect."
  end

  scenario 'with valid user info and declined card' do
    fill_in_valid_user_info
    fill_in_declined_card_info
    click_button "Sign Up"
    expect(page).to have_content "Your card was declined."
  end

  scenario 'with invalid user info and valid card' do
    fill_in_invalid_user_info
    fill_in_valid_credit_card_info
    click_button "Sign Up"
    expect(page).to have_content "can't be blank, is too short (minimum is 5 characters)"
  end

  scenario 'with invalid user info and invalid card' do
    fill_in_invalid_user_info
    fill_in_invalid_credit_card_info
    click_button "Sign Up"
    expect(page).to have_content "can't be blank, is too short (minimum is 5 characters)"
  end

  scenario 'with invalid user info and declined card' do
    fill_in_invalid_user_info
    fill_in_declined_card_info
    click_button "Sign Up"
    expect(page).to have_content "can't be blank, is too short (minimum is 5 characters)"
  end
end

def fill_in_valid_user_info
  fill_in 'Email Address', with: 'john@example.com'
  fill_in 'Password', with: 'password'
  fill_in 'Full Name', with: 'John Doe'
end

def fill_in_valid_credit_card_info
  fill_in "credit_card_number", with: '4242424242424242'
  fill_in "security_code", with: '123'
  select "7 - July", from: "date_month"
  select "2016", from: "date_year"
end

def fill_in_invalid_user_info
  fill_in 'Email Address', with: 'john@example.com'
end

def fill_in_invalid_credit_card_info
  fill_in "credit_card_number", with: '4000000000000127'
  fill_in "security_code", with: '123'
  select "7 - July", from: "date_month"
  select "2016", from: "date_year"
end

def fill_in_declined_card_info
  fill_in "credit_card_number", with: '4000000000000002'
  fill_in "security_code", with: '123'
  select "7 - July", from: "date_month"
  select "2016", from: "date_year"
end
