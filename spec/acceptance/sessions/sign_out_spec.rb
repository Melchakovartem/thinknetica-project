require "rails_helper"

feature "User sign out", '
  In order to end of use site
  As an authenticated User
  I want to be able to sign out
' do
  given(:user) { create(:user) }

  scenario "Authenticated user try sign out" do
    sign_in(user)

    click_on "Log out"

    expect(page).to have_content("Signed out successfully.")
    expect(page).not_to have_content("Log out")
  end
end
