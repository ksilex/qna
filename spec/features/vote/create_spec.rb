require 'rails_helper'

feature 'User can vote for best resource', %q{
  In order to show appreciation
  As an authenticated user
  I'd like to be able to vote for best resource
} do
  given(:user) { create(:user) }
  given!(:answer) { create(:answer) }

  context 'Authenticated user', js: true do
    context 'does question' do
      scenario 'upvote' do
        login(user)
        visit question_path(answer.question)
        within '.question-body' do
          page.find(:css, '.upvote-link').click
          within '.vote-count' do
            expect(page).to have_content '1', exact: true
          end
        end
      end
      scenario 'downvote' do
        login(user)
        visit question_path(answer.question)
        within '.question-body' do
          page.find(:css, '.downvote-link').click
          within '.vote-count' do
            expect(page).to have_content '-1', exact: true
          end
        end
      end
      scenario 'unvote' do
        login(user)
        visit question_path(answer.question)
        within '.question-body' do
          2.times { page.find(:css, '.downvote-link').click }
          within '.vote-count' do
            expect(page).to have_content '0', exact: true
          end
        end
      end
      scenario 'vote change' do
        login(user)
        visit question_path(answer.question)
        within '.question-body' do
          page.find(:css, '.downvote-link').click
          within '.vote-count' do
            expect(page).to have_content '-1', exact: true
          end
          page.find(:css, '.upvote-link').click
          within '.vote-count' do
            expect(page).to have_content '1', exact: true
          end
        end
      end
    end
    context 'does own question' do
      scenario 'upvote' do
        login(answer.question.user)
        visit question_path(answer.question)
        within '.question-body' do
          page.find(:css, '.upvote-link').click
          within '.vote-count' do
            expect(page).to have_content '0', exact: true
          end
        end
      end
      scenario 'downvote' do
        login(answer.question.user)
        visit question_path(answer.question)
        within '.question-body' do
          page.find(:css, '.downvote-link').click
          within '.vote-count' do
            expect(page).to have_content '0', exact: true
          end
        end
      end
    end
    context 'does answer' do
      scenario 'upvote' do
        login(user)
        visit question_path(answer.question)
        within '.answer-body' do
          page.find(:css, '.upvote-link').click
          within '.vote-count' do
            expect(page).to have_content '1', exact: true
          end
        end
      end
      scenario 'downvote' do
        login(user)
        visit question_path(answer.question)
        within '.answer-body' do
          page.find(:css, '.downvote-link').click
          within '.vote-count' do
            expect(page).to have_content '-1', exact: true
          end
        end
      end
      scenario 'unvote' do
        login(user)
        visit question_path(answer.question)
        within '.answer-body' do
          2.times { page.find(:css, '.downvote-link').click }
          within '.vote-count' do
            expect(page).to have_content '0', exact: true
          end
        end
      end
      scenario 'vote change' do
        login(user)
        visit question_path(answer.question)
        within '.answer-body' do
          page.find(:css, '.downvote-link').click
          within '.vote-count' do
            expect(page).to have_content '-1', exact: true
          end
          page.find(:css, '.upvote-link').click
          within '.vote-count' do
            expect(page).to have_content '1', exact: true
          end
        end
      end
    end
    context 'does own answer' do
      scenario 'upvote' do
        login(answer.user)
        visit question_path(answer.question)
        within '.answer-body' do
          page.find(:css, '.upvote-link').click
          within '.vote-count' do
            expect(page).to have_content '0', exact: true
          end
        end
      end
      scenario 'downvote' do
        login(answer.user)
        visit question_path(answer.question)
        within '.answer-body' do
          page.find(:css, '.downvote-link').click
          within '.vote-count' do
            expect(page).to have_content '0', exact: true
          end
        end
      end
    end
  end

  scenario 'Unauthenticated user tries to vote', js: true do
    visit question_path(answer.question)
    within '.question-body' do
      page.find(:css, '.upvote-link').click
    end
    expect(page).to have_current_path new_user_session_path
  end
end
