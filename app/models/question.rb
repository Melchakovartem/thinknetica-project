class Question < ApplicationRecord
  include Votable

  has_many :answers, dependent: :destroy
  has_many :attachments, as: :attachmentable
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :subscriptions, dependent: :destroy

  belongs_to :user

  validates :title, :body, presence: true

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true

  after_create :subscribe

  def is_author?(user)
    user.id == user_id
  end

  def select_answer(answer)
    ActiveRecord::Base.transaction do
      answers.update_all(best: false)
      answer.update!(best: true)
    end
  end

  def subscribe
    self.subscriptions.create(user_id: self.user_id)
  end
end
