def set_current_user(user=nil)
  session[:user_id] = (user || Fabricate(:user)).id
end

def sign_in(a_user=nil)
  user ||= Fabricate(:user)
  visit login_path
  fill_in('Email Address', with: user.email_address)
  fill_in('Password', with: user.password)
  click_button 'Sign In'
end
