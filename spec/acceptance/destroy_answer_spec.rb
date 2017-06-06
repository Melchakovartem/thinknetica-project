require_relative "acceptance_helper"

feature "Destroy answer", '
  In order to delete the answer
  As an author
  I want to be able to destroy the answer
' do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:answer) { create(:answer, question: question) }

  describe "Author of answer" do
    before do
      sign_in user
      answer.update(user: user)
      visit question_path(question)
    end

    scenario "sees link to Delete", js: true do
      within ".answers" do
        expect(page).to have_link "Delete"
      end
    end

    scenario "try to delete his answer", js: true do
      within ".answers" do
        click_on "Delete"

        expect(page).to_not have_content answer.body
      end
    end
  end

  scenario "User isn't author of answer try to destroy answer", js: true do
    sign_in user

    visit question_path(question)

    within ".answers" do
      expect(page).to_not have_link "Delete"
    end
  end
end
