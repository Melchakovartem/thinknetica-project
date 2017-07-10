require 'rails_helper'

RSpec.describe OmniauthCallbacksController, type: :controller do
  let(:user) { create(:user) }

  describe "facebook auth" do
    before do
      request.env["devise.mapping"] = Devise.mappings[:user]
      request.env["omniauth.auth"] = mock_auth_hash(:facebook)
    end

    context "if new user" do
      before do
        auth = mock_auth_hash(:facebook)
      end

      it "redeirects to root path" do
        get :facebook
        expect(response).to redirect_to(root_path)
      end

      it "creates new user" do
        expect do
          get :facebook
        end.to change(User, :count).by(1)
      end
    end

    context "if facebook user is exist" do
      before do
        auth = mock_auth_hash(:facebook)
        authorization = create(:authorization, user: user, provider: auth.provider, uid: auth.uid)
      end

      it "redeirects to root path" do
        get :facebook
        expect(response).to redirect_to(root_path)
      end

      it "doesn't creates new user" do
        expect do
          get :facebook
        end.to_not change(User, :count)
      end
    end
  end

  describe "vkontakte auth" do
    before do
      request.env["devise.mapping"] = Devise.mappings[:user]
      request.env["omniauth.auth"] = mock_auth_hash(:vkontakte)
    end

    context "if new user" do
      it "redeirects to enter email path" do
        get :vk
        expect(response).to render_template "application/enter_email"
      end

      it "doesn't creates new user" do
        expect do
          get :vk
        end.to_not change(User, :count)
      end

      it "doesn't sign in user" do
        get :vk
        expect(controller.current_user).to eq nil
      end
    end

    context "if vkontakte user is exist" do
      before do
        auth = mock_auth_hash(:vkontakte)
        authorization = create(:authorization, user: user, provider: auth.provider, uid: auth.uid)
      end

      it "redeirects to root path" do
        get :vk
        expect(response).to redirect_to(root_path)
      end

      it "doesn't create new user" do
        expect do
          get :vk
        end.to_not change(User, :count)
      end

      it "sign's in user" do
        get :vk
        expect(controller.current_user).to eq user
      end
    end
  end
end
