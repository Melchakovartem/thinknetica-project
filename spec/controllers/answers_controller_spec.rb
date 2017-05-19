require "rails_helper"

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }

  describe "GET #new" do
    before { get :new, params: { question_id: question } }

    it "assigns a new Answer to @answer" do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it "render new view" do
      expect(response).to render_template :new
    end
  end

  describe "POST #create" do
    context "with valid attributes" do
      it "saves new answers in database" do
        expect do
          post :create,
               params: { question_id: question, answer: attributes_for(:answer).except(:question) }
        end.to change(Answer, :count).by(1)
      end

      it "redirect to index view" do
        post :create, params: { question_id: question, answer: attributes_for(:answer).except(:question) }
        expect(response).to redirect_to question_answers_path(assigns(:question))
      end
    end

    context "with invalid attributes" do
      it "doesn't saves new answers in database" do
        expect do
          post :create,
               params: { question_id: question, answer: { body: nil } }.not_to
          change(Answer, :count)
        end
      end

      it "re-renders new view" do
        post :create, params: { question_id: question, answer: { body: nil } }
        expect(response).to render_template :new
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
end
