module HasVotes
  extend ActiveSupport::Concern

  included do
    has_many :votes, dependent: :destroy, as: :parent
  end
end
