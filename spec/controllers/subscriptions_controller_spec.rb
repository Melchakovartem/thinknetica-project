require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  describe "POST #create" do
    let!(:question) { create(:question) }

    context "if user authenticated" do
      sign_in_user

      it "saves new subscription in database" do
        expect { post :create, params: { subscription: { question_id: question.id } }, format: :js }.to change(Subscription, :count).by(1)
      end

      it "returns :ok status" do
        post :create, params: { subscription: { question_id: question.id } }
        expect(response).to have_http_status(:ok)
      end
    end

    context "if user unauthenticated" do
      it "doesn't save new subscription in database" do
        expect { post :create, params: { subscription: { question_id: question.id } }, format: :js }.to_not change(Subscription, :count)
      end
    end
  end

  describe "DELETE #destroy" do
    sign_in_user

    let!(:question) { create(:question) }

    context "if user authenticated" do
      let!(:subscription) { create(:subscription, user_id: @user.id, question_id: question.id) }

      it "destroys subscription from database" do
        expect { delete :destroy, params: { id: subscription.id }, format: :js}.to change(Subscription, :count).by(-1)
      end

      it "returns :ok status" do
        delete :destroy, params: { id: subscription.id }
        expect(response).to have_http_status(:ok)
      end
    end

    context "if user unauthenticated" do
      let!(:subscription) { create(:subscription) }

      it "doesn't save new subscription in database" do
        expect { delete :destroy, params: { id: subscription.id }, format: :js }.to_not change(Subscription, :count)
      end
    end
  end
end
