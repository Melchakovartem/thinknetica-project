shared_examples_for "Commentable" do
  context "one session" do
    scenario "Authenticated user try to comments", js: true do
      sign_in(user)
      visit question_path(question)

      within "#{selector}" do
        click_on "Comment"

        fill_in "Comment", with: "New comment to #{klass_name}"

        click_on "To comment"

        expect(page).to have_content "New comment to #{klass_name}"
      end
    end

    scenario "anuthenticated user try to comments", js: true do
      visit question_path(question)

      within "#{selector}" do
        expect(page).to_not have_link "Comment"
      end
    end
  end
end
