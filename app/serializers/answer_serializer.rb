class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :created_at, :updated_at, :user_id, :body
end
