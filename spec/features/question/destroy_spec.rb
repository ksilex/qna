require 'rails_helper'

feature 'Author can delete question', %q{
  As an author of question
  I'd like to be able to delete question
} do

  given!(:question) { create(:question) }
  background { login(question.user) }

  scenario 'Author tries to delete question' do
    visit question_path(question)
    click_on 'Delete Question'
    expect(page).to have_content 'Your question successfully deleted.'
  end
end