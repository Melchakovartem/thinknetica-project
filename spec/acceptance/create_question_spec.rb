require "rails_helper"

feature "Create question", '
  In order to get answer from community
  As an user
  I want to be able to ask question
  'do

  scenario "Any user creates question" do

    visit questions_path
    click_on "Ask question"
    fill_in "Title", with: "Title of question"
    fill_in "Body", with: "Body of question"
    click_on "Create"
    save_and_open_page
    expect(page).to have_content "Your question succesfully created"
  end
end
