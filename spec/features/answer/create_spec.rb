require 'rails_helper'

feature 'User can create an answer', %q{
  In order to help solving people's problem
  As an authenticated user
  I'd like to be able to answer question
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given(:gist_url) {'https://gist.github.com/vkurennov/743f9367caa1039874af5a2244e1b44c'}

  describe 'Authenticated user' do
    background do
      login(user)

      visit questions_path
      click_on question.title
    end

    scenario 'answers a question', js: true do
      fill_in 'Body', with: 'users answer'
      click_on 'Answer'
      expect(page).to have_content 'users answer'
    end

    scenario 'answers with errors', js: true do
      click_on 'Answer'

      expect(page).to have_content "Body can't be blank"
    end

    scenario 'answers with attached file', js: true do
      fill_in 'Body', with: 'users answer'
      attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Answer'
      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end

    scenario 'answers with multiple links added', js: true do
      fill_in 'Body', with: 'users answer'
      click_on 'Add link'
      names = page.all('.link_name')
      urls = page.all('.link_url')
      names[0].fill_in with: 'My gist'
      names[1].fill_in with: 'My gist 2'
      urls[0].fill_in with: gist_url
      urls[1].fill_in with: gist_url
      click_on 'Answer'
      within '.answers' do
        expect(page).to have_link 'My gist', href: gist_url
        expect(page).to have_link 'My gist 2', href: gist_url
      end
    end
  end

  scenario 'Unauthenticated user tries to answer a question' do
    visit questions_path
    click_on question.title
    click_on 'Answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
