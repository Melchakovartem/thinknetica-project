require_relative "acceptance_helper"

feature "Vote for answer" , "
  In order to feedback
  As an authenticated user
  I'd like to be able to vote for question
" do

  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }
  given(:selector) { ".answers" }
  given(:updating) { answer.update(user: user) }
  given(:new_line) { "\n" }

  it_behaves_like "Votable"

  def update_instance(&updating)
    updating.call
  end
end
