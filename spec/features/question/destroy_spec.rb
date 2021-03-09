require 'rails_helper'

feature 'Author can delete question', %q{
  As an author of question
  I'd like to be able to delete question
} do

  given!(:question) { create(:question) }
  given(:user) { create(:user) }

  scenario 'Author tries to delete question' do
    login(question.user)
    visit question_path(question)
    click_on 'Delete Question'
    expect(page).to have_content 'Your question successfully deleted.'
    expect(page).to_not have_content question.body
    question.answers.each { |answer| expect(page).to_not have_content answer.body }
  end

  scenario 'Signed in user tries to delete question' do
    login(user)
    visit question_path(question)
    expect(page).to_not have_content 'Delete Question'
  end

  scenario 'User tries to delete question' do
    visit question_path(question)
    expect(page).to_not have_content 'Delete Question'
  end
end