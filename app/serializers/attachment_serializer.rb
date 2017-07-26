class AttachmentSerializer < ActiveModel::Serializer
  attributes :url

  delegate :url, to: "object.file"
end
