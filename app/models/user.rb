class User < ApplicationRecord
  SKIPABLE_OAUTH = ["facebook"]

  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :votes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :authorizations, dependent: :destroy

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, :confirmable, omniauth_providers: [:facebook, :vk]

  def self.find_for_oauth(auth)
    authorization = Authorization.where(provider: auth.provider, uid: auth.uid).first
    return authorization.user if authorization

    return unless auth.info[:email]

    email = auth.info[:email]
    user = User.where(email: email).first

    if user
      user.authorizations.create(provider: auth.provider, uid: auth.uid)
    else
      password = Devise.friendly_token[0, 20]

      ActiveRecord::Base.transaction do
        user = User.new(email: email, password: password, password_confirmation: password)
        user.skip_confirmation! if SKIPABLE_OAUTH.include?(auth.provider)
        user.save!
        user.authorizations.create(provider: auth.provider, uid: auth.uid)
      end

    end

    user
  end
end
