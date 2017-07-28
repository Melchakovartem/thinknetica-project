shared_examples_for "Votable" do
  scenario "Unathenticated user try to vote for answer", js: true do
    visit question_path(question)

    within "#{selector}" do
      expect(page).to_not have_link "+1"
      expect(page).to_not have_link "-1"
      expect(page).to_not have_link "Reset"
      expect(page).to have_content "Rating: #{new_line}0"
    end
  end


  describe "Authenticated user" do
    before do
      sign_in user
    end

    scenario "Not author try to vote for answer", js: true do
      visit question_path(question)

      within "#{selector}" do
        click_on "+1"
        expect(page).to_not have_link "+1"
        expect(page).to_not have_link "-1"
        expect(page).to have_link "Reset"
        expect(page).to have_content "Rating:#{new_line}1"

        click_on "Reset"
        expect(page).to have_link "+1"
        expect(page).to have_link "-1"
        expect(page).to_not have_link "Reset"
        expect(page).to have_content "Rating:#{new_line}0"

        click_on "-1"
        expect(page).to_not have_link "+1"
        expect(page).to_not have_link "-1"
        expect(page).to have_link "Reset"
        expect(page).to have_content "Rating:#{new_line}-1"
      end
    end

    scenario "Author try to vote for answer", js: true do
      update_instance { updating }

      visit question_path(question)

      within "#{selector}" do
        expect(page).to_not have_link "+1"
        expect(page).to_not have_link "-1"
        expect(page).to_not have_link "Reset"
        expect(page).to have_content "Rating: #{new_line}0"
      end
    end
  end
end
