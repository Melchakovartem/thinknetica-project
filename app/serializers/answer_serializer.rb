class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :body, :created_at, :updated_at

  has_many :comments, each_serializer: CommentSerializer
  has_many :attachments, each_serializer: AttachmentSerializer
end
