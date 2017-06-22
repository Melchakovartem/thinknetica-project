require_relative "acceptance_helper"

feature "Vote for answer" , "
  In order to feedback
  As an authenticated user
  I'd like to be able to vote for question
" do

  given(:user) { create(:user) }
  given!(:question) { create(:question) }

  scenario "Unathenticated user try to vote for question", js: true do
    visit question_path(question)

    within ".question" do
      expect(page).to_not have_content "+1"
      expect(page).to_not have_content "-1"
      expect(page).to_not have_content "Reset"
      expect(page).to have_content "Rating: 0"
    end
  end


  describe "Authenticated user" do
    before do
      sign_in user
    end

    scenario "Not author try to vote for question", js: true do
      visit question_path(question)

      within ".question" do
        click_on "+1"
        expect(page).to_not have_content "+1"
        expect(page).to_not have_content "-1"
        expect(page).to have_content "Reset"
        expect(page).to have_content "Rating: 1"

        click_on "Reset"
        expect(page).to have_content "+1"
        expect(page).to have_content "-1"
        expect(page).to_not have_content "Reset"
        expect(page).to have_content "Rating: 0"

        click_on "-1"
        expect(page).to_not have_content "+1"
        expect(page).to_not have_content "-1"
        expect(page).to have_content "Reset"
        expect(page).to have_content "Rating: -1"
      end
    end

    scenario "Author try to vote for question", js: true do
      question.update(user_id: user.id)

      visit question_path(question)

      within ".question" do
        expect(page).to_not have_content "+1"
        expect(page).to_not have_content "-1"
        expect(page).to_not have_content "Reset"
        expect(page).to have_content "Rating: 0"
      end
    end
  end
end
