class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user
  validates :body, presence: true
  validate :one_best_answer, on: :update

  scope :sort_by_best, -> { order(best: :desc) }

  def mark_as_best
    transaction do
      Answer.where(question_id: question_id).update_all(best: false)
      update(best: true)
    end
	end

  def one_best_answer
    errors.add(:best, "Can't mark multiple answers") if question.answers.where(best: true).count > 1
  end
end
