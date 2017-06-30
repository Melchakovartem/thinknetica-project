require_relative 'acceptance_helper'

feature 'Add comments to answer', %q{
  In order to clarify answer
  As an anuthenticated user
  I'd like to be able to comment answer
} do

  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }


  context "one session" do
    scenario 'Authenticated user try to comments answer', js: true do
      sign_in(user)
      visit question_path(question)

      within ".answers" do
        click_on 'Comment'

        fill_in 'Comment', with: 'New comment to answer'

        click_on 'To comment'

        expect(page).to have_content 'New comment to answer'
      end
    end

    scenario 'anuthenticated user try to comments question', js: true do
      visit question_path(question)

      within ".answers" do
        expect(page).to_not have_content 'New comment to answer'
      end
    end
  end

  context "multiple sessions" do
    scenario 'all users see new answer in real-time', js: true do
      Capybara.using_session('author') do
        sign_in(user)
        visit question_path(question)

        within ".answers" do
          click_on 'Comment'
          fill_in 'Comment', with: 'Comment-1 to answer'
          click_on 'To comment'

          expect(page).to have_content 'Comment-1 to answer'
        end
      end

      Capybara.using_session('user') do
        sign_in(another_user)
        visit question_path(question)

        within ".answers" do
          click_on 'Comment'
          fill_in 'Comment', with: 'Comment-2 to answer'
          click_on 'To comment'

          expect(page).to have_content 'Comment-1 to answer'
          expect(page).to have_content 'Comment-2 to answer'
        end
      end

      Capybara.using_session('guest') do
        visit question_path(question)

        within ".answers" do
          expect(page).to have_content 'Comment-1 to answer'
          expect(page).to have_content 'Comment-2 to answer'
        end
      end
    end
  end
end
