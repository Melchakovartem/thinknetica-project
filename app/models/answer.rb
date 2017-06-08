class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :body, presence: true

  def is_author?(user)
    user.id == user_id
  end
end
