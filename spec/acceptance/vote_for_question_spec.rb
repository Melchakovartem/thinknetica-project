require_relative "acceptance_helper"

feature "Vote for answer" , "
  In order to feedback
  As an authenticated user
  I'd like to be able to vote for question
" do

  given(:user) { create(:user) }
  given!(:question) { create(:question) }
  given(:selector) { ".question" }
  given(:updating) { question.update(user: user) }
  given(:new_line) { "" }

  it_behaves_like "Votable"

  def update_instance(&updating)
    updating.call
  end
end
