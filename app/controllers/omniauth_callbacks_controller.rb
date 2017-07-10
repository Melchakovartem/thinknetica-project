class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    @user = User.find_for_oauth(request.env['omniauth.auth'])
    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: "facebook") if is_navigational_format?
    end
  end

  def vk
    auth = request.env['omniauth.auth']
    authorization = Authorization.where(provider: auth.provider, uid: auth.uid).first
    if authorization
      sign_in_and_redirect authorization.user, event: :authentication
    else
      cookies[:uid] = auth.uid
      cookies[:provider] = auth.provider
      @user = User.new
      render "application/enter_email"
    end
  end
end
