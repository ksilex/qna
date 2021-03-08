require 'rails_helper'

feature 'User can view answers', %q{
  In order to get answers to question
  I'd like to be able to view answers
} do

  given!(:answers) { create_list(:answer, 3) }

  describe 'User' do

    scenario 'views question answers' do
      visit questions_path
      click_on class: 'title', match: :first
      answers.each { |answer| expect(page).to have_content answer.body }
    end
  end
end