require 'rails_helper'

feature 'User can edit his answer', %q{
  In order to correct mistakes
  As an author of answer
  I'd like ot be able to edit my answer
} do

  given!(:answer) { create(:answer) }
  given(:user) { create(:user) }

  scenario 'Unauthenticated can not edit answer' do
    visit question_path(answer.question)

    expect(page).to_not have_link 'Edit Answer'
  end

  describe 'Author' do
    scenario 'edits his answer', js: true do
      login(answer.user)
      visit question_path(answer.question)
      click_on 'Edit Answer'
      within '.answers' do
        fill_in 'Body', with: 'edited answer'
        click_on 'Answer'
        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edits his answer with errors'
    scenario "tries to edit other user's question"
  end
end