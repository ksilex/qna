require 'sphinx_helper'

feature 'User can search resources', %q{
  In order to get specific resources
  I'd like to be able to search resources
} do

  given!(:answer) { create(:answer, body: 'test') }
  given!(:user) { create(:user, email: 'test@gmail.com') }
  given!(:question) { create(:question, body: 'test') }
  given!(:comment) { create(:comment, body: 'test', parent: answer) }

  given!(:answers) { create_list(:answer, 3) }
  given!(:users) { create_list(:user, 3) }
  given!(:questions) { create_list(:question, 3) }
  given!(:comments) { create_list(:comment, 3, parent: answer) }

  Search::RESOURCES.each do |resource|
    scenario "User searches in #{resource.pluralize}", sphinx: true, js: true do
      visit root_path
      ThinkingSphinx::Test.run do
        fill_in 'Search', with: 'test'
        check "resources_#{resource}"
        click_on 'Search'
        expect(page).to have_content 'test'
        eval(resource.pluralize).each { |obj| expect(page).to_not have_content obj.class == User ? obj.email : obj.body}
      end
    end
  end

  scenario "User searches in all resources", sphinx: true, js: true do
    visit root_path
    ThinkingSphinx::Test.run do
      fill_in 'Search', with: 'test'
      click_on 'Search'
      expect(page).to have_content 'test'
      expect(page).to have_selector('.card', count: 4)
    end
  end
end
