require "rails_helper"

RSpec.describe SearchController, type: :controller do
  describe 'GET #search' do
    let!(:user) { create(:user, email: "search@mail.ru") }
    let!(:question) { create(:question, title: "search") }
    let!(:answer) { create(:answer, body: "search") }
    let!(:comment) { create(:comment, body: "search", commentable: question) }

    %w(Answer Question Comment User).each do |model|
      context "Search in #{model}" do
        it 'assigns search results' do
          get :search, params: { q: "search", model: model }
          expect(assigns(:results))
        end

        it 'renders search view' do
          get :search, params: { query: "search", model: model}
          expect(response).to render_template :search
        end
      end
    end

    context "Search in everywhere" do
      it 'assigns search results' do
        get :search, params: { q: "search", model: "" }
        expect(assigns(:results))
      end

      it 'renders search view' do
        get :search, params: { query: "search", model: ""}
        expect(response).to render_template :search
      end
    end
  end
end
