require 'rails_helper'

feature 'User can select best answer', %q{
  In order to indicate which answer solved problem
  As an author of question
  I'd like ot be able to select best answer
} do
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }
  given(:second_answer) { create(:answer, question: question) }
  given(:answers_list) { create_list(:answer, 10, question: question) }
  given(:user) { create(:user) }

  describe 'Author' do
    scenario 'selects best answer', js: true do
      login(question.user)
      visit question_path(question)
      click_on 'Mark as best'
      expect(page).to have_selector '.best-answer'
    end

    describe 'multiple answers' do
      background do
        answer.mark_as_best
        second_answer
        login(question.user)
        visit question_path(question)
      end
      scenario 'selects other as best answer', js: true do
        within "[data-answer-id='#{second_answer.id}']" do
          click_on 'Mark as best'
        end

        expect(page).to have_selector ".best-answer[data-answer-id='#{second_answer.id}']"
      end
      scenario 'page has only one best answer' do
        expect(page).to have_selector '.best-answer', count: 1
      end
      scenario 'best answer listed first' do
        answers_list
        expect(page.find(:css, '.answer', match: :first)[:class]).to include 'best-answer'
      end
    end
  end

  scenario 'Signed in user tries to mark answer as best' do
    login(user)
    visit question_path(question)
    expect(page).to_not have_content 'Mark as best'
  end

  scenario 'Unauthenticated user tries to mark answer as best' do
    visit question_path(question)
    expect(page).to_not have_content 'Mark as best'
  end
end
