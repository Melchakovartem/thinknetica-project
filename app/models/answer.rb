class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  has_many :attachments, as: :attachmentable, dependent: :destroy
  has_many :votes, as: :votable, dependent: :destroy

  validates :body, presence: true

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true

  def is_author?(user)
    user.id == user_id
  end

  def has_vote_from_user(user)
    votes.find_by(user_id: user.id)
  end
end
