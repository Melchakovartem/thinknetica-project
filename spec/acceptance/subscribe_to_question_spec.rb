require_relative "acceptance_helper"

feature "Subscribe to question", '
  In order to get answer from community
  As an authenticated user
  I want to be able to subscribe to answers
  ' do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  scenario "Authenticated user try to create question", js: true do
    sign_in(user)

    visit question_path(question)
    within ".question" do
      click_on "Subscribe"

      expect(page).to have_link "Unsubscribe"
      expect(page).to_not have_link "Subscribe"

      click_on "Unsubscribe"

      expect(page).to_not have_link "Unsubscribe"
      expect(page).to have_link "Subscribe"
    end
  end

  scenario "Unauthenticated user to create question", js: true do
    visit question_path(question)

    within ".question" do
      expect(page).to_not have_content "Unsibscribe"
      expect(page).to_not have_content "Subscribe"
    end
  end
end
