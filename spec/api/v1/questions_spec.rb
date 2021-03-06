require "rails_helper"

describe "Questions API" do
  describe "GET /index" do
    let!(:questions) { create_list(:question, 2) }
    let!(:question) { questions.first }
    let!(:answer) { create(:answer, question: question) }
    let(:request) { get "/api/v1/questions" }

    it_behaves_like "API Authenticable"

    context "authorized" do
      let(:access_token) { create(:access_token) }

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
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("1/#{attr}")
        end
      end
    end
  end

  describe "GET /show" do
    let!(:user) { create(:user) }
    let!(:question) { create(:question) }
    let!(:comment) { create(:comment, commentable: question, user: user) }
    let!(:attachment) { create(:attachment, attachmentable: question) }
    let(:request) { get "/api/v1/questions/#{question.id}" }

    it_behaves_like "API Authenticable"


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

  describe "POST /create" do
    let(:request) { post "/api/v1/questions" }

    it_behaves_like "API Authenticable"

    context "authorized" do
      let!(:user) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }

      it "responds status :created" do
        post "/api/v1/questions", params: { question: attributes_for(:question),
                                  format: :json, access_token: access_token.token }
        expect(response).to have_http_status(:created)
      end

      %w(id title body created_at updated_at).each do |attr|
        it "contains #{attr}" do
          post "/api/v1/questions", params: { question: attributes_for(:question),
                                  format: :json, access_token: access_token.token }
          id = JSON.parse(response.body)["id"]
          question = Question.find(id)
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("#{attr}")
        end
      end

      it "creates question" do
        expect do
          post "/api/v1/questions", params: { question: attributes_for(:question),
                                    format: :json, access_token: access_token.token }
        end.to change { Question.count }.by(1)
      end
    end
  end

  def do_request(options = {}, &request)
    request.call params: { format: :json }.merge(options)
  end
end
