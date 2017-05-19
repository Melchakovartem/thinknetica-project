require "rails_helper"

RSpec.describe QuestionsController, type: :controller do
  describe "GET #new" do
    before { get :new }

    it "assigns a new Question to @question" do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it "renders new view" do
      expect(response).to render_template :new
    end
  end

  describe "POST #create" do
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

  describe "GET #show" do
    let(:question) { create(:question) }

    before { get :show, params: { id: question } }

    it "assigns requested question to @question" do
      expect(assigns(:question)).to eq question
    end

    it "render show view" do
      expect(response).to render_template :show
    end
  end
end
