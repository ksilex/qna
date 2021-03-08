require 'rails_helper'

feature 'Author can delete answer', %q{
  As an author of answer
  I'd like to be able to delete answer
} do

  given!(:answer) { create(:answer) }
  background { login(answer.user) }

  scenario 'Author tries to delete answer' do
    visit question_path(answer.question)
    click_on 'Delete Answer'
    expect(page).to have_content 'Your answer successfully deleted.'
    expect(page).to_not have_content answer.body
  end
end
