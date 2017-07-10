class ConfirmationsController < ApplicationController
  def create
    @user = User.find_for_oauth_vk(email: params[:user][:email], provider: cookies[:provider], uid: cookies[:uid])
    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
    end
  end
end
