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
      @user = User.find_for_oauth(auth)
      return check_user_confirmation(auth.provider) if @user
      session[:provider] = auth.provider
      session[:uid] = auth.uid
      render "application/enter_email"
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

    def auth
      request.env['omniauth.auth'] ||
      OmniAuth::AuthHash.new(provider: session[:provider], uid: session[:uid],
                             info: { email: params[:email] })
    end
end
