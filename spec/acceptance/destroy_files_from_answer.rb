require_relative "acceptance_helper"

feature "Destroy files from answer", "
  In order to attach wrong file
  As an author of answer
  I'd like to be able destroy attached files
" do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:answer) { create(:answer, question: question)}
  given!(:attachment) { create(:attachment, attachmentable_id: answer.id, attachmentable_type: answer.class.name)}
  given(:klass_name) { answer.class_name }
  given(:selector) { ".attachments_answer" }
  given(:updating) { answer.update(user: user) }

  it_behaves_like "Destroy Attachmentable"

  def update_instance(&updating)
    updating.call
  end
end
