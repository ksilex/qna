require 'rails_helper'

feature 'User can view questions', %q{
  In order to answer questions
  I'd like to be able to view questions
} do

  given!(:questions) { create_list(:question, 3) }

  describe 'User' do

    scenario 'views questions' do
      visit questions_path
      questions.each { |question| expect(page).to have_content question.title }
    end
  end
end
