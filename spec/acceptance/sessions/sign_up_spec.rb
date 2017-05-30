require "rails_helper"

feature "User sign up", '
  In order to have extended rights
  As an unregistered User
  I want to be able to sign up
' do

  given(:user) { create(:user) }

  scenario "Unregistered user try sign up" do
    visit new_user_registration_path
    fill_in "Email", with: "new_user@test.com"
    fill_in "Password", with: "123456"
    fill_in "Password confirmation", with: "123456"
    click_on "Sign up"

    expect(page).to have_content "Welcome! You have signed up successfully."
    expect(current_path).to eq root_path
  end

  scenario "Registered user try sign up" do
    sign_up(user)

    expect(page).to have_content "Email has already been taken"
    expect(current_path).to eq user_registration_path
  end
end
