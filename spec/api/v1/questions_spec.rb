require "rails_helper"

describe "Questions API" do
  describe "GET /index" do
    context "unauthorized" do

      before do
        get "/api/v1/questions", params: { format: :json }
      end

      it "returns 401 status if there is no access_token" do
        expect(response.status).to eq 401
      end

      it "returns 401 status if acces_token is invalid" do
        expect(response.status).to eq 401
      end
    end

    context "authorized" do
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }
      let!(:answer) { create(:answer, question: question) }

      before do
        get "/api/v1/questions", params: { format: :json, access_token: access_token.token }
      end

      it "returns 200 status" do
        expect(response).to be_success
      end

      it "returns list of questions" do
        expect(response.body).to have_json_size(2)
      end

      %w(id title body created_at updated_at).each do |attr|
        it "question object contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("0/#{attr}")
        end
      end
    end
  end
end
