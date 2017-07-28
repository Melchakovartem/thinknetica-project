require_relative 'acceptance_helper'

feature 'Add comments to question', %q{
  In order to clarify question
  As an anuthenticated user
  I'd like to be able to comment question
} do

  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question) }
  given(:klass_name) { question.class.name }
  given(:selector) { ".question" }

  it_behaves_like "Commentable"

  context "multiple sessions" do
    scenario 'all users see new comment in real-time', js: true do
      Capybara.using_session('author') do
        sign_in(user)
        visit question_path(question)

        within ".question" do
          click_on 'Comment'
          fill_in 'Comment', with: 'Comment-1 to question'
          click_on 'To comment'

          expect(page).to have_content 'Comment-1 to question'
        end
      end

      Capybara.using_session('user') do
        sign_in(another_user)
        visit question_path(question)

        within ".question" do
          click_on 'Comment'
          fill_in 'Comment', with: 'Comment-2 to question'
          click_on 'To comment'

          expect(page).to have_content 'Comment-1 to question'
          expect(page).to have_content 'Comment-2 to question'
        end
      end

      Capybara.using_session('guest') do
        visit question_path(question)

        within ".question" do
          expect(page).to have_content 'Comment-1 to question'
          expect(page).to have_content 'Comment-2 to question'
        end
      end
    end
  end
end
