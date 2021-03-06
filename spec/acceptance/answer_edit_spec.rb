require_relative "acceptance_helper"

feature "Answer editing" , "
  In order to fix mistake
  As an author of answer
  I'd like to be able to edit my answer
" do

  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }

  scenario "Unathenticated user try to edit answer", js: true do
    visit question_path(question)

    expect(page).to_not have_link "Edit"
  end

  describe "Authenticated user" do
    before do
      sign_in user
    end

    describe "is author of the answer" do
      before do
        answer.update(user_id: user.id)
        visit question_path(question)
      end

      scenario "sees link to Edit" do
        within ".answers" do
          expect(page).to have_link "Edit"
        end
      end

      scenario "try to edit his answer", js: true do
        click_on "Edit"

        within ".answers" do
        fill_in "Answer", with: "edited answer"
          click_on "Save"

          expect(page).to_not have_content answer.body
          expect(page).to have_content "edited answer"
          expect(page).to_not have_selector "textarea"
        end
      end
    end

    describe "isn't author of the answer" do
      before do
        visit question_path(question)
      end

      scenario "try to edit other user's answer", js: true do
        within ".answers" do
          expect(page).to have_content answer.body
          expect(page).to_not have_link "Edit"
        end
      end
    end
  end
end
