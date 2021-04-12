class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :created_at, :updated_at, :title, :body
  has_many :answers
  has_many :files, serializer: FileSerializer
  belongs_to :user
end
