require_relative "acceptance_helper"

feature "Destroy files from question", "
  In order to attach wrong file
  As an author of question
  I'd like to be able destroy attached files
" do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:attachment) { create(:attachment, attachmentable_id: question.id, attachmentable_type: question.class.name) }
  given(:klass_name) { question.class_name }
  given(:selector) { ".attachments_question" }
  given(:updating) { question.update(user: user) }

  it_behaves_like "Destroy Attachmentable"

  def update_instance(&updating)
    updating.call
  end
end
