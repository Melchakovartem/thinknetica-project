require_relative "acceptance_helper"

feature "Select best answer" , "
  In order if the problem is solved
  As an author of question
  I'd like to be able to select best question
" do

  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:first_answer) { create(:answer, question: question) }
  given!(:second_answer) { create(:answer, question: question) }

  scenario "Unathenticated user try to select best answer", js: true do
    visit question_path(question)

    expect(page).to_not have_link "Select"
  end

  describe "Authenticated user" do
    before do
      sign_in user
    end

    describe "is author of the question" do
      before do
        question.update(user_id: user.id)
        visit question_path(question)
      end

      scenario "sees link to Select" do
        within ".answers" do
          expect(page).to have_link "Select"
        end
      end

      scenario "try to select best answer if answer is not selected", js: true do
        within ".answers" do
          find(".answer-#{first_answer.id}").click_on "Select"

          expect(find('span:first-child')).to have_content first_answer.body
          expect(find('span:first-child')).to have_css(".best_answer")
        end
      end


      scenario "try to select best answer if answer is selected", js: true do

        within ".answers" do
          find(".answer-#{first_answer.id}").click_on "Select"
          find(".answer-#{second_answer.id}").click_on "Select"

          expect(find('span:first-child')).to have_content second_answer.body
          expect(find('span:first-child')).to have_css(".best_answer")
        end
      end
    end

    describe "isn't author of the question" do
      before do
        visit question_path(question)
      end

      scenario "try to select best answer", js: true do
        within ".answers" do
          expect(page).to_not have_link "Select"
        end
      end
    end
  end
end
