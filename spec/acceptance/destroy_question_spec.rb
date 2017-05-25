require "rails_helper"

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
    click_on "Delete"

    expect(page).to have_content "Your question succesfully deleted"
    expect(page).not_to have_content question.body
    expect(current_path).to eq questions_path
  end

  scenario "User isn't author of question try to destroy question" do

    sign_in(user)

    visit question_path(question)
    click_on "Delete"

    expect(page).to have_content "You haven't rights for this action"
    expect(current_path).to eq question_path(question)
  end
end

