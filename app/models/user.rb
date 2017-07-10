class User < ApplicationRecord
  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :votes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :authorizations, dependent: :destroy

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, omniauth_providers: [:facebook, :vk]

  def self.find_for_oauth(auth)
    authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
    return authorization.user if authorization

    email = auth.info[:email]
    user = User.where(email: email).first
    if user
      user.create_authoriztion(auth)
    else
      password = Devise.friendly_token[0, 20]
      user = User.create!(email: email, password: password, password_confirmation: password)
      user.create_authoriztion(auth)
    end
    user
  end

  def self.find_for_oauth_vk(params)
    provider = params[:provider]
    uid = params[:uid].to_s
    authorization = Authorization.where(provider: provider, uid: uid).first
    return authorization.user if authorization

    email = params[:email]
    user = User.where(email: email).first
    if user
      user.authorizations.create(provider: provider, uid: uid)
    else
      password = Devise.friendly_token[0, 20]
      user = User.create!(email: email, password: password, password_confirmation: password)
      user.authorizations.create(provider: provider, uid: uid)
    end
    user
  end

  def create_authoriztion(auth)
    authorizations.create(provider: auth.provider, uid: auth.uid)
  end
end
