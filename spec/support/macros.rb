def set_current_user(user=nil)
  session[:user_id] = (user || Fabricate(:user)).id
end

def set_current_admin(admin=nil)
  session[:user_id] = (admin || Fabricate(:admin)).id
end

def sign_in(user=nil)
  user ||= Fabricate(:user)
  visit login_path
  fill_in('Email Address', with: user.email_address)
  fill_in('Password', with: user.password)
  click_button 'Sign In'
end

def sign_out
  click_link "Sign Out"
end

def click_on_video_on_home_page(video)
  find("a[href='/videos/#{video.token}']").click
end
