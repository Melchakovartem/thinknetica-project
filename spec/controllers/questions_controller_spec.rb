require "rails_helper"

RSpec.describe QuestionsController, type: :controller do
  describe "GET #new" do
    context "if user authenticated" do
      sign_in_user

      before { get :new }

      it "assigns a new Question to @question" do
        expect(assigns(:question)).to be_a_new(Question)
      end

      it "renders new view" do
        expect(response).to render_template :new
      end
    end

    context "if user unauthenticated" do
      before { get :new }

      it "doesn't assigns a new Question to @question" do
        expect(assigns(:question)).not_to be_a_new(Question)
      end

      it "redirects to sign up" do
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe "POST #create" do
    context "if user authenticated" do
      sign_in_user

      context "with valid attributes" do
        it "saves new question in database" do
          expect { post :create, params: { question: attributes_for(:question) } }.to change(Question, :count).by(1)
        end

        it "redirects to show view" do
          post :create, params: { question: attributes_for(:question) }
          expect(response).to redirect_to question_path(assigns(:question))
        end
      end

      context "with invalid attributes" do
        it "doesn't save question in database" do
          expect { post :create, params: { question: attributes_for(:invalid_question) } }.not_to change(Question, :count)
        end

        it "re-renders new view" do
          post :create, params: { question: attributes_for(:invalid_question) }
          expect(response).to render_template :new
        end
      end
    end

    context "if user unauthenticated" do
      it "doesn't save new question in database" do
        expect { post :create, params: { question: attributes_for(:question) } }.not_to change(Question, :count)
      end

      it "redirects to sign up" do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe "GET #show" do
    let!(:question) { create(:question) }
    let!(:answers) { create_list(:answer, 5, question: question) }

    before { get :show, params: { id: question } }

    it "assigns requested question to @question" do
      expect(assigns(:question)).to eq question
    end

    it "assigns answers to question to @answers" do
      expect(assigns(:answers)).to match_array(answers)
    end

    it "render show view" do
      expect(response).to render_template :show
    end
  end

  describe "GET #index" do
    let(:questions) { create_list(:question, 3) }

    before { get :index }

    it "assigns requested questions to @questions" do
      expect(assigns(:questions)).to eq questions
    end

    it "render index view" do
      expect(response).to render_template :index
    end
  end

  describe "DELETE #destroy" do
    sign_in_user

    context "if user is author of question" do
      let(:question) { create(:question, user: @user) }

      before { delete :destroy, params: { id: question } }

      it "checks record in database" do
        expect(Question.where(id: question.id)).not_to exist
      end
    end

    context "if user isn't author of question" do
      let(:question) { create(:question) }

      before { delete :destroy, params: { id: question } }

      it "checks record in database" do
        expect(Question.where(id: question.id)).to exist
      end
    end
  end

  describe "PATCH #update" do
    context "Unauthenticated user" do
      let(:question) { create(:question) }

      before do
        patch :update, params: { id: question, question: { body: "new body" } }, format: :js
      end

      it "doesn't change question attributes" do
        expect(question.reload.body).to eq question.body
      end

      it "responds with status :unauthorized" do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "Authenticated user" do
      sign_in_user

      context "Author of the answer" do
        let!(:question) { create(:question, user: @user) }

        before do
          patch :update, params: { id: question.id, question: { body: "new body" } }, format: :js
        end

        it "changes question attributes" do
          expect(question.reload.body).to eq "new body"
        end

        it "render update template" do
          expect(response).to render_template :update
        end
      end

      context "if user isn't author of question" do
        let!(:question) { create(:question) }

        it "doesn't change question attributes" do
          patch :update, params: { id: question, question: { body: "new body" } }, format: :js
          expect(question.reload.body).to eq question.body
        end
      end
    end
  end
end
