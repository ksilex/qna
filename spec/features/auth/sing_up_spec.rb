require 'rails_helper'

feature 'User can sign up', %q{
  In order to ask questions and answer
  As an unauthenticated user
  I'd like to be able to sign up
} do

  scenario 'User tries to sign up' do
    visit root_path
    click_on 'Sign Up'
    fill_in 'Email', with: 'test@test.com'
    fill_in 'Password', with: '123456'
    fill_in 'Password confirmation', with: '123456'
    click_on 'Sign up'
    open_email('test@test.com')
    current_email.click_link 'Confirm'
    expect(page).to have_content 'Your email address has been successfully confirmed.'
  end

  scenario 'User tries to sign up with errors' do
    visit root_path
    click_on 'Sign Up' #link to form
    click_on 'Sign up' #button
    expect(page).to have_content "Email can't be blank"
  end

  context 'vkontakte' do
    before do
      Rails.application.env_config["devise.mapping"] = Devise.mappings[:user]
      Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[:vkontakte]
    end
    scenario 'sign up/in user' do
      Rails.application.env_config["omniauth.auth"].info.email = 'test@mail.com'
      visit new_user_session_path
      click_on 'Sign in with Vkontakte'
      expect(page).to have_content 'Successfully authenticated from Vkontakte account.'
    end
    context 'no email' do
      before { Rails.application.env_config["omniauth.auth"].info.email = nil }

      scenario 'sign up user with no email provided' do
        visit new_user_session_path
        click_on 'Sign in with Vkontakte'
        fill_in 'Email', with: 'test@mail.com'
        click_on 'Confirm email'
        open_email('test@mail.com')
        current_email.click_link 'Confirm'
        expect(page).to have_content 'Your email address has been successfully confirmed.'
      end

      scenario 'sign in user with no email provided' do
        visit new_user_session_path
        click_on 'Sign in with Vkontakte'
        fill_in 'Email', with: 'test@mail.com'
        click_on 'Confirm email'
        open_email('test@mail.com')
        current_email.click_link 'Confirm'
        click_on 'Sign Out'

        visit new_user_session_path
        click_on 'Sign in with Vkontakte'
        expect(page).to have_content 'Successfully authenticated from Vkontakte account.'
      end
    end
  end

  context 'github' do
    before do
      Rails.application.env_config["devise.mapping"] = Devise.mappings[:user]
      Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[:github]
    end

    scenario 'sign up/in user' do
      Rails.application.env_config["omniauth.auth"].info.email = 'test@mail.com'
      visit new_user_session_path
      click_on 'Sign in with GitHub'
      expect(page).to have_content 'Successfully authenticated from Github account.'
    end

    context 'no email' do
      before { Rails.application.env_config["omniauth.auth"].info.email = nil }

      scenario 'sign up user with no email provided' do
        visit new_user_session_path
        click_on 'Sign in with GitHub'
        fill_in 'Email', with: 'test@mail.com'
        click_on 'Confirm email'
        open_email('test@mail.com')
        current_email.click_link 'Confirm'
        expect(page).to have_content 'Your email address has been successfully confirmed.'
      end

      scenario 'sign in user with no email provided' do
        visit new_user_session_path
        click_on 'Sign in with GitHub'
        fill_in 'Email', with: 'test@mail.com'
        click_on 'Confirm email'
        open_email('test@mail.com')
        current_email.click_link 'Confirm'
        click_on 'Sign Out'

        visit new_user_session_path
        click_on 'Sign in with GitHub'
        expect(page).to have_content 'Successfully authenticated from Github account.'
      end
    end
  end
end
