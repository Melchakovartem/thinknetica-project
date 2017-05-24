require "rails_helper"

feature "View question and answers", '
  In order to find correct answer to question
  As an user
  I want to be able to view question and answers
' do
  given!(:question) { create(:question) }
  given!(:answers) { create_list(:answer, 5, question: question) }

  scenario "User try to view question and answers" do

    visit question_path(question)

    expect(page).to have_content question.body
    expect(page).to have_content answers.first.body
    expect(page).to have_content answers.last.body
  end
end
