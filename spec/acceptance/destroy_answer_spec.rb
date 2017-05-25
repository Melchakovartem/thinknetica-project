require "rails_helper"

feature "Destroy answer", '
  In order to delete the answer
  As an author
  I want to be able to destroy the answer
' do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:user_answer) { create(:answer, user: user, question: question) }
  given(:answer) { create(:answer, question: question) }

  scenario "Author of answer try to destroy answer" do

    sign_in(user)

    visit question_answer_path(question, user_answer)
    click_on "Delete"

    expect(page).to have_content "Your answer succesfully deleted"
    expect(current_path).to eq question_path(question)
  end

  scenario "User isn't author of answer try to destroy answer" do

    sign_in(user)

    visit question_answer_path(question, answer)
    click_on "Delete"

    expect(page).to have_content "You haven't rights for this action"
    expect(current_path).to eq question_answer_path(question, answer)
  end
end

