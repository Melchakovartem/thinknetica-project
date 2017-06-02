require_relative "acceptance_helper"

feature "Answer to question", '
  In order to help with problem
  As an authenticated user
  I want to be to answer the question
' do
  given!(:question) { create(:question) }
  given!(:user) { create(:user) }

  scenario "Authenticated user try to answer the question", js: true do
    sign_in(user)

    visit question_path(question)
    fill_in "Body", with: "Answer the question"
    click_on "Answer"

    expect(current_path).to eq question_path(question)
    within ".answers" do
      expect(page).to have_content "Answer the question"
    end
  end

  scenario "Unauthenticated user try to answer the question" do
    visit question_path(question)
    fill_in "Body", with: "Answer the question"
    click_on "Answer"

    redirect_to_sign_in
  end
end
