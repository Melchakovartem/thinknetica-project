require_relative "acceptance_helper"

feature "Sign in from social networks", '
  In order to have extended rights
  As an unregistered User
  I want to be able to sign in from social networks
  ' do
  given(:user) { create(:user) }

  scenario "User try sign up from facebook", js: true do
    mock_auth_hash(:facebook)
    visit new_user_session_path

    expect(page).to have_content('Sign in with Facebook')

    click_on "Sign in with Facebook"

    expect(page).to have_content "Successfully authenticated from facebook account."
    expect(current_path).to eq root_path
  end

  scenario "User try sign in from facebook", js: true do
    auth = mock_auth_hash(:facebook)
    user.update!(email: auth.info[:email])
    user.authorizations.create(provider: auth.provider, uid: auth.uid)

    visit new_user_session_path

    expect(page).to have_content('Sign in with Facebook')

    click_on "Sign in with Facebook"

    expect(page).to have_content "Successfully authenticated from facebook account."
    expect(current_path).to eq root_path
  end

  scenario "User try sign up from vkontakte" do
    mock_auth_hash(:vk)
    visit new_user_session_path

    expect(page).to have_content('Sign in with Facebook')

    click_on "Sign in with Vk"

    fill_in "auth_info_email", with: "new_user@test.com"
    click_on "Create"

    open_email("new_user@test.com")
    current_email.click_link "Confirm my account"

    expect(page).to have_content "Your email address has been successfully confirmed."
    expect(current_path).to eq new_user_session_path

    click_on "Sign in with Vk"

    expect(page).to have_content "Successfully authenticated from vkontakte account."
    expect(current_path).to eq root_path
  end

  scenario "User try sign in from vkontakte" do
    auth = mock_auth_hash(:vk)
    user.update!(email: "test@test.com")
    user.authorizations.create(provider: auth.provider, uid: auth.uid)

    visit new_user_session_path

    expect(page).to have_content('Sign in with Vk')

    click_on "Sign in with Vk"

    expect(page).to have_content "Successfully authenticated from vkontakte account."
    expect(current_path).to eq root_path
  end
end
