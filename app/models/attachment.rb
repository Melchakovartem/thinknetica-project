class Attachment < ApplicationRecord
  belongs_to :attachmentable, polymorphic: true, optional: true

  mount_uploader :file, FileUploader

  def is_author?(user)
    user.id == attachmentable.user_id
  end
end
