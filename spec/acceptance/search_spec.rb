require_relative "acceptance_helper"

feature "Search text", '
  In order to search text on site
  As an user
  I want to be able to find text
  ' do
  given!(:user) { create(:user, email: "text@mail.ru") }
  given!(:question) { create(:question, title: "text") }
  given!(:answer) { create(:answer, body: "text") }
  given!(:comment) { create(:comment, body: "text", commentable: question) }

  %w(Question Answer Comment User).each do |model|
    scenario "User can search #{model}", js: true do
      ThinkingSphinx::Test.run do
         visit root_path

         fill_in "Search", with: "text"

         select model, from: "model"

         click_on "Find"

        expect(page).to have_content "text"
      end
    end
  end

  scenario "User can search everywhere", js: true do
    ThinkingSphinx::Test.run do
      visit root_path

      fill_in "Search", with: "text"

      click_on "Find"

      expect(page).to have_content question.title
      expect(page).to have_content answer.body
      expect(page).to have_content comment.body
      expect(page).to have_content user.email
    end
  end
end
