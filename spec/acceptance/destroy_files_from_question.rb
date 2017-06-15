require_relative "acceptance_helper"

feature "Destroy files from question", "
  In order to attach wrong file
  As an author of question
  I'd like to be able destroy attached files
" do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:attachment) { create(:attachment, attachmentable_id: question.id, attachmentable_type: question.class.name)}

  describe "Author of question" do
    before do
      sign_in user
      question.update(user: user)
      visit question_path(question)
    end

    scenario "sees link to Delete file", js: true do
      within ".attachments_question" do
        expect(page).to have_link "Delete file"
      end
    end

    scenario "try to delete attachments", js: true do
      within ".attachments_question" do
        click_on "Delete file"

        expect(page).to_not have_content attachment.file.filename
      end
    end
  end

  scenario "User isn't author of answer try to destroy answer", js: true do
    sign_in user

    visit question_path(question)

    within ".attachments_question" do
      expect(page).to_not have_link "Delete file"
    end
  end
end
