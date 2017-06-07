require "rails_helper"

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }

  describe "GET #new" do
    context "if authenticated user" do
      sign_in_user

      before { get :new, params: { question_id: question } }

      it "assigns a new Answer to @answer" do
        expect(assigns(:answer)).to be_a_new(Answer)
      end

      it "render new view" do
        expect(response).to render_template :new
      end
    end

    context "if unauthenticated user" do
      before { get :new, params: { question_id: question } }

      it "doesn't assigns a new Answer to @answer" do
        expect(assigns(:answer)).not_to be_a_new(Answer)
      end

      it "redirects to sign in" do
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe "POST #create" do
    context "if authenticated user" do
      sign_in_user

      context "with valid attributes" do
        it "saves new answer in database" do
          expect do
            post :create,
                 params: { question_id: question, answer: attributes_for(:answer).except(:question, :user),
                           format: :js }
          end.to change(question.answers, :count).by(1)
        end
      end

      context "with invalid attributes" do
        it "doesn't saves new answer in database" do
          expect do
            post :create,
                 params: { question_id: question, answer: { body: nil }, format: :js }.not_to
            change(question.answerss, :count)
          end
        end
      end
    end

    context "if unauthenticated user" do
      it "doesn't save new answer in database" do
        expect do
          post :create,
               params: { question_id: question, answer: attributes_for(:answer).except(:question, :user) }
        end.not_to change(question.answers, :count)
      end

      it "redirects to sign in" do
        post :create, params: { question_id: question, answer: attributes_for(:answer).except(:question, :user) }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe "GET #index" do
    let(:answers) { create_list(:answer, 3, question: question) }

    before { get :index, params: { question_id: question } }

    it "populates an array of all answers" do
      expect(assigns(:answers)).to match_array(answers)
    end

    it "renders index view" do
      expect(response).to render_template :index
    end
  end

  describe "GET #show" do
    let(:answer) { create(:answer, question: question) }

    before { get :show, params: { question_id: question, id: answer } }

    it "assigns requested answer to @answer" do
      expect(assigns(:answer)).to eq answer
    end

    it "render show view" do
      expect(response).to render_template :show
    end
  end

  describe "DELETE #destroy" do
    sign_in_user

    context "if user is author of answer" do
      let(:answer) { create(:answer, question: question, user: @user) }

      it "checks record in database" do
        delete :destroy, params: { question_id: question, id: answer }, format: :js
        expect(Answer.where(id: answer.id)).not_to exist
      end
    end

    context "if user isn't author of question" do
      let(:answer) { create(:answer, question: question) }

      it "checks record in database" do
        delete :destroy, params: { question_id: question, id: answer }, format: :js
        expect(Answer.where(id: answer.id)).to exist
      end
    end
  end

  describe "PATCH #update" do
    context "Unauthenticated user" do
      let(:answer) { create(:answer, question: question) }

      before do
        patch :update, params: { id: answer, question_id: question, answer: { body: "new body" } }, format: :js
      end

      it "doesn't change answer attributes" do
        expect(answer.reload.body).to eq answer.body
      end

      it "responds with status :unauthorized" do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "Authenticated user" do
      sign_in_user

      context "Author of the answer" do
        let!(:answer) { create(:answer, question: question, user: @user) }

        before do
          patch :update, params: { id: answer, question_id: question, answer: { body: "new body" } }, format: :js
        end

        it "changes answer attributes" do
          expect(answer.reload.body).to eq "new body"
        end

        it "render update template" do
          expect(response).to render_template :update
        end
      end

      context "if user isn't author of question" do
        let(:answer) { create(:answer, question: question) }

        it "doesn't change answer attributes" do
          patch :update, params: { id: answer, question_id: question, answer: { body: "new body" } }, format: :js
          expect(answer.reload.body).to eq answer.body
        end
      end
    end
  end

  describe "PATCH #select" do
    context "Unauthenticated user" do
      let!(:question) { create(:question) }
      let!(:answer) { create(:answer, question: question) }


      it "doesn't set best answer for question" do
        patch :select, params: { id: answer, question_id: question }, format: :js
        expect(question.reload.best_answer_id).to be_nil
      end

      it "doesn't set best answer for question" do
        expect(question.reload.best_answer_id).to be_nil
      end
    end

    context "Authenticated user" do
      sign_in_user

      context "Author of the question" do
        let!(:question) { create(:question, user: @user) }
        let(:first_answer) { create(:answer, question: question) }
        let(:second_answer) { create(:answer, question: question) }

        context "if question is not selected" do
          it "sets best answer for question" do
            patch :select, params: { id: first_answer, question_id: question }, format: :js
            expect(question.reload.best_answer_id).to eq first_answer.id
          end
        end

        context "if question is selected" do
          let(:second_answer) { create(:answer, question: question) }

          before do
            question.update(best_answer_id: first_answer.id)
            patch :select, params: { id: second_answer, question_id: question }, format: :js
          end

          it "sets best answer for question" do
            expect(question.reload.best_answer_id).to eq second_answer.id
          end
        end
      end

      context "if user isn't author of question" do
        let!(:question) { create(:question) }
        let(:answer) { create(:answer, question: question) }

        it "doesn't set best answer for question" do
          patch :select, params: { id: answer, question_id: question }, format: :js
          expect(question.reload.best_answer_id).to be_nil
        end
      end
    end
  end
end
