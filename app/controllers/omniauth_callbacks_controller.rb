class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    auth = request.env['omniauth.auth']
    @user = User.find_for_oauth(auth)

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
      render "application/enter_email", locals: { auth: auth }
    end
  end

  def confirm_email
    auth = OmniAuth::AuthHash.new(params['auth'])
    @user = User.find_for_oauth(auth)
    if @user.persisted?
      @user.send_confirmation_instructions
      redirect_to root_path
    end
  end
end
