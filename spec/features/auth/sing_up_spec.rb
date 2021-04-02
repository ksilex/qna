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
    expect(page).to have_content 'A message with a confirmation link has been sent to your email address.'
  end

  scenario 'User tries to sign up with errors' do
    visit root_path
    click_on 'Sign Up' #link to form
    click_on 'Sign up' #button
    expect(page).to have_content "Email can't be blank"
  end
end
