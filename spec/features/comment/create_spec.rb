require 'rails_helper'

feature 'User can add comments to resource', %q{
  In order to discuss resource
  As an authenticated user
  I'd like to be able to add comments to resource
} do
  given(:user) { create(:user) }
  given!(:answer) { create(:answer) }

  context 'Authenticated user', js: true do
    background do
      Capybara.using_session('guest') do
        visit question_path(answer.question)
      end

      login(user)
      visit question_path(answer.question)
    end

    scenario 'adds comment to answer' do
      within '.answers' do
        click_on 'Leave your comment'
        fill_in 'Body', with: 'new comment'
        click_on 'Comment'
      end
      expect(page).to have_content 'new comment'

      Capybara.using_session('guest') do
        expect(page).to have_content 'new comment'
      end
    end

    scenario 'adds comment to answer with errors' do
      within '.answers' do
        click_on 'Leave your comment'
        fill_in 'Body', with: ''
        click_on 'Comment'
      end
      expect(page).to have_content "Body can't be blank"

      Capybara.using_session('guest') do
        expect(page).to_not have_selector '.comment'
      end
    end

    scenario 'adds comment to question' do
      within '.question-comments' do
        click_on 'Leave your comment'
        fill_in 'Body', with: 'new comment'
        click_on 'Comment'
      end
      expect(page).to have_content 'new comment'

      Capybara.using_session('guest') do
        expect(page).to have_content 'new comment'
      end
    end

    scenario 'adds comment to question with errors' do
      within '.question-comments' do
        click_on 'Leave your comment'
        fill_in 'Body', with: ''
        click_on 'Comment'
      end
      expect(page).to have_content "Body can't be blank"

      Capybara.using_session('guest') do
        expect(page).to_not have_selector '.comment'
      end
    end
  end

  scenario 'Unauthenticated user tries to comment', js: true do
    visit question_path(answer.question)
    click_on 'Leave your comment', match: :first
    expect(page).to have_current_path new_user_session_path
  end
end
