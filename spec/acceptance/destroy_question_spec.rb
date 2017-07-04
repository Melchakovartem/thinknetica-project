require_relative "acceptance_helper"

feature "Destroy question", '
  In order to delete the question
  As an author
  I want to be able to destroy the question
' do

  given(:user) { create(:user) }
  given(:user_question) { create(:question, user: user) }
  given(:question) { create(:question) }

  scenario "Author of question try to destroy question" do
    sign_in(user)

    visit question_path(user_question)

    within ".question" do
      click_on "Delete"
    end

    expect(page).to have_content "Question was successfully destroyed."
    expect(page).not_to have_content question.body
    expect(current_path).to eq questions_path
  end

  scenario "User isn't author of question try to destroy question" do
    sign_in(user)

    visit question_path(question)

    within ".question" do
      expect(page).to_not have_content "Delete"
    end
  end
end
