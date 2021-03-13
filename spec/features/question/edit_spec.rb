require 'rails_helper'

feature 'User can edit his question', %q{
  In order to correct mistakes
  As an author of question
  I'd like ot be able to edit my question
} do

  given!(:question) { create(:question) }
  given(:question_of_other_user) { create(:question) }

  scenario 'Unauthenticated can not edit question' do
    visit questions_path

    expect(page).to_not have_link 'Edit Question'
  end

  describe 'Author' do
    scenario 'edits his question' do
      login(question.user)
      visit questions_path
      click_on 'Edit Question'
      fill_in 'Body', with: 'edited question'
      click_on 'Update Question'

      expect(page).to_not have_content question.body
      expect(page).to have_content 'edited question'
    end

    scenario 'edits his answer with errors' do 
      login(question.user)
      visit questions_path
      click_on 'Edit Question'
      fill_in 'Body', with: ''
      click_on 'Update Question'
      
      expect(page).to have_content "Body can't be blank"
    end

    scenario "tries to edit other user's question" do 
      question_of_other_user
      login(question.user)
      visit questions_path
      within "[data-question-id='#{question_of_other_user.id}']" do
        expect(page).to_not have_link 'Edit'
      end
    end
  end
end