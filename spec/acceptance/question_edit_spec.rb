require_relative "acceptance_helper"

feature "Question editing" , "
  In order to fix mistake
  As an author of question
  I'd like to be able to edit my question
" do

  given(:user) { create(:user) }
  given!(:question) { create(:question) }

  scenario "Unathenticated user try to edit question" do
    visit questions_path

    expect(page).to_not have_link "Edit"
  end

  describe "Authenticated user" do
    before do
      sign_in user
    end

    describe "is author of the question" do
      before do
        question.update(user_id: user.id)
        visit questions_path
      end

      scenario "sees link to Edit" do
        within ".questions" do
          expect(page).to have_link "Edit"
        end
      end

      scenario "try to edit his answer", js: true do
        click_on "Edit"

        within ".questions" do
          fill_in "question_title", with: "edited question title"
          fill_in "question_body", with: "edited question body"
          click_on "Save"

          expect(page).to_not have_content question.title
          expect(page).to have_content "edited question title"
          expect(page).to_not have_selector "textarea"
        end
      end
    end

    describe "isn't author of the answer" do
      before do
        visit questions_path
      end

      scenario "try to edit other user's answer" do
        within ".questions" do
          expect(page).to have_content question.title
          expect(page).to_not have_link "Edit"
        end
      end
    end
  end
end
