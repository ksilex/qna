require 'rails_helper'

feature 'Author can delete attached links', %q{
  As an author of resource
  I'd like to be able to delete attached links
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, :with_link) }
  given(:answer) { create(:answer, :with_link, question: question) }

  context 'of question' do
    given!(:question) { create(:question, :with_link) }

    scenario 'Author tries to delete link', js: true do
      login(question.user)
      visit question_path(question)
      click_on 'Delete Link'
      expect(page).to_not have_link 'test', href: 'https://test.com'
    end

    scenario 'Signed in user tries to delete link' do
      login(user)
      visit question_path(question)
      expect(page).to_not have_content 'Delete Link'
    end
  end

  context 'of answer' do
    given!(:answer) { create(:answer, :with_link) }

    scenario 'Author tries to delete link', js: true do
      login(answer.user)
      visit question_path(answer.question)
      click_on 'Delete Link'
      expect(page).to_not have_link 'test', href: 'https://test.com'
    end

    scenario 'Signed in user tries to delete link' do
      login(user)
      visit question_path(answer.question)
      expect(page).to_not have_content 'Delete Link'
    end
  end

  scenario 'User tries to delete link' do
    visit question_path(answer.question)
    expect(page).to_not have_content 'Delete Link'
  end

end
