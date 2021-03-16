require 'rails_helper'

feature 'Author can delete attached files', %q{
  As an author of resource
  I'd like to be able to delete attached files
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, :with_file) }
  given(:answer) { create(:answer, :with_file, question: question) }

  context 'of question' do
    given!(:question) { create(:question, :with_file) }

    scenario 'Author tries to delete file', js: true do
      login(question.user)
      visit question_path(question)
      click_on 'Delete File'
      expect(page).to_not have_link 'rails_helper.rb'
    end

    scenario 'Signed in user tries to delete file' do
      login(user)
      visit question_path(question)
      expect(page).to_not have_content 'Delete File'
    end
  end

  context 'of answer' do
    given!(:answer) { create(:answer, :with_file) }

    scenario 'Author tries to delete file', js: true do
      login(answer.user)
      visit question_path(answer.question)
      click_on 'Delete File'
      expect(page).to_not have_link 'rails_helper.rb'
    end

    scenario 'Signed in user tries to delete file' do
      login(user)
      visit question_path(answer.question)
      expect(page).to_not have_content 'Delete File'
    end
  end

  scenario 'User tries to delete file' do
    visit question_path(answer.question)
    expect(page).to_not have_content 'Delete File'
  end
  
end