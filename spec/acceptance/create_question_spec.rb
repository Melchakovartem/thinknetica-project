require_relative "acceptance_helper"

feature "Create question", '
  In order to get answer from community
  As an user
  I want to be able to ask question
  ' do
  given(:user) { create(:user) }

  context "one session" do
    scenario "Authenticated user try to create question" do
      sign_in(user)

      visit questions_path
      click_on "Ask question"
      fill_in "Title", with: "Title of question"
      fill_in "Body", with: "Body of question"
      click_on "Create"

      expect(page).to have_content "Your question succesfully created"
      expect(page).to have_content "Title of question"
      expect(page).to have_content "Body of question"
    end

    scenario "Anauthenticated user to create question" do
      visit questions_path
      click_on "Ask question"

      redirect_to_sign_in
    end
  end

  context "multiple sessions", js: true do
    scenario "all users see new question in real-time" do
      Capybara.using_session('author') do
        sign_in(user)
        visit questions_path
      end

      Capybara.using_session('guest') do
        visit questions_path
      end

      Capybara.using_session('author') do
        click_on "Ask question"
        fill_in "Title", with: "Title of question"
        fill_in "Body", with: "Body of question"
        click_on "Create"

        expect(page).to have_content "Your question succesfully created"
        expect(page).to have_content "Title of question"
        expect(page).to have_content "Body of question"
      end

      Capybara.using_session('guest') do
        expect(page).to have_content "Title of question"
      end
    end
  end
end
