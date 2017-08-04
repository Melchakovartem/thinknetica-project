class SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_subscription, only: [:destroy]

  authorize_resource
  respond_to :js

  def create
    @question_id = params[:question_id]
    @subscription = current_user.subscriptions.create(question_id: @question_id)
  end

  def destroy
    respond_with @subscription.destroy
  end

  private

    def set_subscription
      @subscription = Subscription.find(params[:id])
    end
end
