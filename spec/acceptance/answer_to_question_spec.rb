require "rails_helper"

feature "Answer to question", '
  In order to help with problem
  As an user
  I want to be to answer the question
' do
  given!(:question) { create(:question) }

  scenario "Any user can answer" do

    visit question_path(question)
    fill_in "Body", with: "Answer the question"
    click_on "Answer"

    expect(page).to have_content "Your answer succefully created"
    expect(current_path).to eq question_answers_path(question)
  end
end
