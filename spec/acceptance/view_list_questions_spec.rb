require_relative "acceptance_helper"

feature "View the list of questions", '
  In order to view list of questions
  As an user
  I want to be able to see all questions
' do
  given!(:questions) { create_list(:question, 3) }

  scenario "Any user views list of question" do
    visit questions_path

    expect(page).to have_content questions.first.title
    expect(page).to have_content questions.last.title
  end
end
