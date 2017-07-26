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

  describe "GET /show" do
    let!(:user) { create(:user) }
    let!(:question) { create(:question) }
    let!(:comment) { create(:comment, commentable: question, user: user) }
    let!(:attachment) { create(:attachment, attachmentable: question) }

    context "unauthorized" do

      before do
        get "/api/v1/questions/#{question.id}", params: { format: :json }
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

      before do
        get "/api/v1/questions/#{question.id}", params: { format: :json, access_token: access_token.token }
      end

      it "returns 200 status" do
        expect(response).to be_success
      end

      %w(id title body created_at updated_at).each do |attr|
        it "question object contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("#{attr}")
        end
      end

      context 'comments' do
        it 'included in question object' do
          expect(response.body).to have_json_size(1).at_path("comments")
        end

        it "contains body" do
          expect(response.body).to be_json_eql(comment.body.to_json).at_path("comments/0/body")
        end
      end

      context 'attachments' do
        it 'included in question object' do
          expect(response.body).to have_json_size(1).at_path("attachments")
        end

        it "contains url" do
          expect(response.body).to be_json_eql(attachment.file.url.to_json).at_path("attachments/0/url")
        end
      end
    end
  end
end
