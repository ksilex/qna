require 'rails_helper'

feature 'User can view rewards', %q{
  In order to get info about rewards
  I'd like to be able to view rewards
} do

  given(:question) { create(:question, :with_reward) }
  given!(:answer) { create(:answer, question: question) }

  describe 'User' do
    scenario 'views his profile' do
      answer.mark_as_best
      login(answer.user)
      visit profile_path
      expect(page).to have_content question.reward.name
      expect(page).to have_content question.title
      expect(page.find('.rounded-3')['src']).to have_content question.reward.file.filename
    end
  end
end
