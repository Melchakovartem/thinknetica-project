require "rails_helper"

describe "Answers API" do
  let!(:question) { create(:question) }

  describe "GET /index" do
    let!(:answers) { create_list(:answer, 2, question: question) }
    let(:answer) { answers.last }
    let(:request) { get "/api/v1/questions/#{question.id}/answers" }

    it_behaves_like "API Authenticable"

    context "authorized" do
      let(:access_token) { create(:access_token) }

      before do
        get "/api/v1/questions/#{question.id}/answers", params: { format: :json, access_token: access_token.token }
      end

      it "returns 200 status" do
        expect(response).to be_success
      end

      it "returns list of answers" do
        expect(response.body).to have_json_size(2)
      end

      %w(id body created_at updated_at).each do |attr|
        it "question object contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("0/#{attr}")
        end
      end
    end
  end

  describe "GET /show" do
    let!(:user) { create(:user) }
    let!(:answer) { create(:answer) }
    let!(:comment) { create(:comment, commentable: answer, user: user) }
    let!(:attachment) { create(:attachment, attachmentable: answer) }
    let(:request) { get "/api/v1/answers/#{answer.id}" }

    it_behaves_like "API Authenticable"


    context "authorized" do
      let(:access_token) { create(:access_token) }

      before do
        get "/api/v1/answers/#{answer.id}", params: { format: :json, access_token: access_token.token }
      end

      it "returns 200 status" do
        expect(response).to be_success
      end

      %w(id body created_at updated_at).each do |attr|
        it "question object contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("#{attr}")
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

  describe "POST /create" do
    let(:request) { post "/api/v1/questions/#{question.id}/answers" }

    it_behaves_like "API Authenticable"

    context "authorized" do
      let!(:user) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }

      it "responds status :created" do
        post "/api/v1/questions/#{question.id}/answers",
        params: { answer: attributes_for(:answer), format: :json, access_token: access_token.token }
        expect(response).to have_http_status(:created)
      end

      %w(id body created_at updated_at).each do |attr|
        it "contains #{attr}" do
          post "/api/v1/questions/#{question.id}/answers",
          params: { answer: attributes_for(:answer), format: :json, access_token: access_token.token }
          id = JSON.parse(response.body)["id"]
          answer = Answer.find(id)
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("#{attr}")
        end
      end

      it "creates question" do
        expect do
          post "/api/v1/questions/#{question.id}/answers",
          params: { answer: attributes_for(:answer), format: :json, access_token: access_token.token }
        end.to change { Answer.count }.by(1)
      end
    end
  end

  def do_request(options = {}, &request)
    request.call params: { format: :json }.merge(options)
  end
end
