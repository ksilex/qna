require 'rails_helper'

feature 'User can view questions', %q{
  In order to answer questions
  I'd like to be able to view questions
} do

  given!(:questions) { create_list(:question, 3) }

  describe 'user' do

    scenario 'views questions' do
      visit questions_path
      expect(page).to have_content questions.first.title
      expect(page).to have_content questions.last.body
    end
  end
end
