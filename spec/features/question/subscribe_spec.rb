require 'rails_helper'

feature 'User can subscribe to questions', %q{
  In order to get notifications about new answers
  I'd like to be able to subscribe to question
} do

  given!(:question) { create(:question) }
  given(:user) { create(:user) }

  context 'Authenticated user' do
    scenario 'subscribes to question' do
      login(user)
      visit question_path(question)
      click_on 'Subscribe'
      expect(page).to have_content 'You will get notifications about new answers'
      expect(page).to_not have_content 'Subscribe'
    end
    scenario 'unsubscribes from question' do
      login(user)
      visit question_path(question)
      click_on 'Subscribe'
      click_on 'Unsubscribe'
      expect(page).to have_content 'Unsubscribed successfully'
      expect(page).to_not have_content 'Unsubscribe', exact: true
    end
  end

  scenario 'Unauthenticated user cant subscribe' do
    visit question_path(question)
    click_on 'Subscribe'
    expect(current_path).to eq new_user_session_path
  end
end
