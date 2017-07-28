require_relative 'acceptance_helper'

feature 'Add files to answer', %q{
  In order to illustrate my answer
  As an answer's author
  I'd like to be able to attach files
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:selector) { ".answers" }
  given (:button) { "Answer" }
  given(:fill_in_block) do
    fill_in "Body", with: "Body of question"
  end

  background do
    sign_in(user)
    visit question_path(question)
  end

  it_behaves_like "Attachmentable"

  def fill_in_text_fields(&fill_in_block)
    fill_in_block.call
  end
end
