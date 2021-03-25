require 'rails_helper'

feature 'User can vote for best resource', %q{
  In order to show appreciation
  As an authenticated user
  I'd like to be able to vote for best resource
} do
  given(:user) { create(:user) }
  given!(:answer) { create(:answer) }

  describe 'Authenticated user', js: true do

    scenario 'upvotes question' do
      login(user)
      visit question_path(answer.question)
      within '.question-body' do
        page.find(:css, '.upvote-link', match: :first).click
        within '.vote-count' do
          expect(page).to have_content '1'
        end
      end
    end

    scenario 'upvotes answer' do
      login(user)
      visit question_path(answer.question)
      within '.answers' do
        click_on class: 'upvote-link'
        expect(page).to have_content '1'
      end
    end
  end
end
