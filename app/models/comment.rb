class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :parent, polymorphic: true

  validates :body, presence: true
end
