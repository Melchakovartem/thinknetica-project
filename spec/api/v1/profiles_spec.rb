require "rails_helper"

describe "Profile API" do
  describe "GET /me" do
    let(:request) { get "/api/v1/profiles/me" }

    it_behaves_like "API Authenticable"

    context "authorized" do
      let(:me) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before do
        get "/api/v1/profiles/me", params: { format: :json, access_token: access_token.token }
      end

      it "returns 200 status" do
        expect(response).to be_success
      end

      %w(id email created_at updated_at).each do |attr|
        it "contains #{attr}" do
          expect(response.body).to be_json_eql(me.send(attr.to_sym).to_json).at_path(attr)
        end
      end


      %w(password encrypted_password).each do |attr|
        it "doesn't contain #{attr}" do
          expect(response.body).to_not have_json_path(attr)
        end
      end
    end
  end

  describe " GET index" do
    context "unauthorized" do
      let(:request) { get "/api/v1/profiles" }

      it_behaves_like "API Authenticable"
    end

    context "authorized" do
      let(:me) { create(:user) }
      let!(:another_user) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: me.id) }

      before do
        get "/api/v1/profiles", params: { format: :json, access_token: access_token.token }
      end

      it "returns 200 status" do
        expect(response).to be_success
      end

      %w(id email created_at updated_at).each do |attr|
        it "contains #{attr} of another user" do
          expect(response.body).to be_json_eql(another_user.send(attr.to_sym).to_json).at_path("0/#{attr}")
        end
      end


      %w(password encrypted_password).each do |attr|
        it "doesn't contain #{attr}" do
          expect(response.body).to_not have_json_path(attr)
        end
      end
    end
  end

  def do_request(options = {}, &request)
    request.call params: { format: :json }.merge(options)
  end
end
