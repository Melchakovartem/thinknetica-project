class SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_subscription, only: [:destroy]

  authorize_resource

  def create
    subscription = current_user.subscriptions.create(subscription_params)
    render json: { subscription_id: subscription.id }
  end

  def destroy
    render json: @subscription.destroy
  end

  private

    def subscription_params
      params.require(:subscription).permit(:question_id)
    end

    def set_subscription
      @subscription = Subscription.find(params[:id])
    end
end
