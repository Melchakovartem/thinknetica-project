class BasicQuestionSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :created_at, :updated_at
end
