require 'rails_helper'

feature 'Author can delete answer', %q{
  As an author of answer
  I'd like to be able to delete answer
} do

  given!(:answer) { create(:answer) }
  given(:user) { create(:user) }

  scenario 'Author tries to delete answer', js: true  do
    login(answer.user)
    visit question_path(answer.question)
    click_on 'Delete Answer'
    expect(page).to_not have_content answer.body
  end

  scenario 'Signed in user tries to delete answer' do
    login(user)
    visit question_path(answer.question)
    expect(page).to_not have_content 'Delete Answer'
  end

  scenario 'User tries to delete answer' do
    visit question_path(answer.question)
    expect(page).to_not have_content 'Delete Answer'
  end
end
