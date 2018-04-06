# system specs
def login(user=nil)
  user ||= create(:user)
  visit new_user_session_path
  fill_in("Email", with: user.email)
  fill_in("Password", with: user.password)
  click_button("Log in")
end

def expect_to_see(text)
  expect(page).to have_content(text)
end

def expect_not_to_see(content)
  expect(page).not_to have_content(content)
end
