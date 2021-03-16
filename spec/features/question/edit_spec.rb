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
    context 'his question' do
      background do
        login(question.user)
        visit questions_path
        click_on 'Edit Question'
      end

      scenario 'edits his question', js: true do
        fill_in 'Title', with: 'edited title'
        click_on 'Update Question'
        
        expect(page).to have_content 'edited title'
        expect(page).to_not have_selector 'textarea'
      end

      scenario 'edits question and attaches file', js: true do
        fill_in 'Title', with: 'edited title'
        attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Update Question'
        click_on 'edited title'
        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end

      scenario 'edits his answer with errors', js: true do 
        fill_in 'Body', with: ''
        click_on 'Update Question'
        
        expect(page).to have_content "Body can't be blank"
      end
    end

    scenario "tries to edit other user's question" do 
      question_of_other_user
      login(question.user)
      visit questions_path
      within "[data-question-id='#{question_of_other_user.id}']" do
        expect(page).to_not have_link 'Edit Question'
      end
    end
  end
end