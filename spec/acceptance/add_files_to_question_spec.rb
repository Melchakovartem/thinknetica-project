require_relative 'acceptance_helper'

feature 'Add files to question', %q{
  In order to illustrate my question
  As an question's author
  I'd like to be able to attach files
} do

  given(:user) { create(:user) }
  given(:selector) { ".question" }
  given(:button) { "Create" }
  given(:fill_in_block) do
    fill_in "Title", with: "Test of question"
    fill_in "Body", with: "Body of question"
  end


  background do
    sign_in(user)
    visit new_question_path
  end

  it_behaves_like "Attachmentable"

  def fill_in_text_fields(&fill_in_block)
    fill_in_block.call
  end
end
