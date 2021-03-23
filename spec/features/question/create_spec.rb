require 'rails_helper'

feature 'User can create question', %q{
  In order to get answer from a community
  As an authenticated user
  I'd like to be able to ask the question
} do

  given(:user) { create(:user) }
  given(:gist_url) {'https://gist.github.com/vkurennov/743f9367caa1039874af5a2244e1b44c'}

  describe 'Authenticated user' do
    background do
      login(user)

      visit questions_path
      click_on 'Ask question'
    end

    scenario 'asks a question', js: true do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'
      click_on 'Create Question'
      expect(page).to have_content 'Test question'
    end

    scenario 'asks a question with errors', js: true do
      click_on 'Create Question'

      expect(page).to have_content "Title can't be blank"
    end

    scenario 'asks a question with attached file', js: true do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'
      attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
      click_on 'Create Question'
      click_on 'Test question'
      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end

    scenario 'asks a question with attached link', js: true do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'
      2.times { click_on 'Add link' }
      names = page.all('.link_name')
      urls = page.all('.link_url')
      names[0].fill_in with: 'My gist'
      names[1].fill_in with: 'My gist 2'
      urls[0].fill_in with: gist_url
      urls[1].fill_in with: gist_url
      click_on 'Create Question'
      click_on 'Test question'
      expect(page).to have_link 'My gist', href: gist_url
      expect(page).to have_link 'My gist 2', href: gist_url
    end

    scenario 'asks a question with attached reward', js: true do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'
      click_on 'Add Reward'
      fill_in 'Name', with: 'reward'
      attach_file 'File', file_fixture('ec08c343da0011779330e0ed7d7313f6e0bfb50d_full.jpg')
      click_on 'Create Question'
      click_on 'Test question'
      expect(page.find('.rounded-3')['src']).to have_content 'ec08c343da0011779330e0ed7d7313f6e0bfb50d_full.jpg'
    end
  end

  scenario 'Unauthenticated user tries to ask a question' do
    visit questions_path
    click_on 'Ask question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
