class Question < ApplicationRecord
  has_many :answers, dependent: :destroy

  belongs_to :user

  validates :title, :body, presence: true

  def is_author?(user)
    user.id == user_id
  end
end
