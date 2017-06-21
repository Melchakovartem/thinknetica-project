class Vote < ApplicationRecord
  belongs_to :votable, polymorphic: true
  belongs_to :user

  validates :votable_id, :votable_type, :value, presence: true
  validates :value, inclusion: { in: %w(1 -1), message: "Value must be 1 and -1" }
  validates :user_id, uniqueness: { scope: [:votable_id, :votable_type] }

  def is_author?(user)
    user.id == user_id
  end
end
