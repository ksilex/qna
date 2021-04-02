module FeatureHelpers
  OmniAuth.config.test_mode = true
  def login(user)
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'
  end

  def mock_auth
    OmniAuth.config.mock_auth[:vkontakte] = OmniAuth::AuthHash.new({
      :provider => 'vkontakte',
      :uid => '123545',
      info: { email: "test@gmail.com" }
    })
  end
end
