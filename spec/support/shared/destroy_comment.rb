shared_examples_for "Destroy Attachmentable" do
    describe "Author of instance" do
    before do
      sign_in user
      update_instance { updating }
      visit question_path(question)
    end

    scenario "sees link to Delete file", js: true do
      within "#{selector}" do
        expect(page).to have_link "Delete file"
      end
    end

    scenario "try to delete attachments", js: true do
      within "#{selector}" do
        click_on "Delete file"

        expect(page).to_not have_content attachment.file.filename
      end
    end
  end

  scenario "User isn't author of instance try to destroy attachment", js: true do
    sign_in user

    visit question_path(question)

    within "#{selector}" do
      expect(page).to_not have_link "Delete file"
    end
  end
end
