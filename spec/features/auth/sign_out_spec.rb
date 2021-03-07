require 'rails_helper'

feature 'User can sign out', %q{
  As an unauthenticated user
  I'd like to be able to sign out
} do

  given(:user) { create(:user) }
  background { login(user) }

  scenario 'Signed user tries to sign out' do
    click_on 'Sign Out'
    expect(page).to have_content 'Signed out successfully.'
  end
end
