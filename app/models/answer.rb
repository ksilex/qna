class Answer < ApplicationRecord
  include HasVotes

  belongs_to :question
  belongs_to :user
  has_many :links, dependent: :destroy, as: :parent

  accepts_nested_attributes_for :links, reject_if: :all_blank

  has_many_attached :files

  validates :body, presence: true
  validate :one_best_answer, on: :update

  scope :sort_by_best, -> { order(best: :desc) }

  def mark_as_best
    transaction do
      Answer.where(question_id: question_id).update_all(best: false)
      update!(best: true)
      question&.reward&.update!(user_id: user_id)
    end
	end

  def one_best_answer
    errors.add(:best, "Can't mark multiple answers") if question.answers.where(best: true).count > 1
  end
end
