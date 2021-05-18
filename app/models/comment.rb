class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :parent, polymorphic: true, touch: true

  validates :body, presence: true

  scope :order_by_dt, -> { order(created_at: :desc) }
end
