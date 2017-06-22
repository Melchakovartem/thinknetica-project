module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def has_vote_from_user(user)
    votes.find_by(user_id: user.id)
  end

  def rating
    votes.sum(&:value)
  end
end
