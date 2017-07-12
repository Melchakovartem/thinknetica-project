class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :social_auth

  def facebook
  end

  def vk
  end

  def confirm_email
  end

  private

    def social_auth
      auth = request.env['omniauth.auth'] || OmniAuth::AuthHash.new(params['auth'])
      @user = User.find_for_oauth(auth)
      return check_user_confirmation(auth.provider) if @user
      render "application/enter_email", locals: { auth: auth }
    end

    def check_user_confirmation(provider)
      return sign_in_from_oauth(provider) if @user.confirmed?
      @user.send_confirmation_instructions
      redirect_to new_user_session_path
    end

    def sign_in_from_oauth(provider)
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: provider) if is_navigational_format?
    end
end
