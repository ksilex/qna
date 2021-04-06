class AnswersController < ApplicationController
  include VotingFeatureForControllers

  before_action :authenticate_user!
  after_action :push_answer, only: :create

  authorize_resource

  def edit
    authorize! :edit, answer
  end

  def create
    @answer = question.answers.new(answer_params)
    @answer.user = current_user
    @answer.save
  end

  def update
    answer.update(answer_params)
  end

  def destroy
    authorize! :destroy, answer
    answer.destroy
  end

  def best
    authorize! :best, answer
    answer.mark_as_best
    @reward = answer.question.reward
    @answers = answer.question.answers.sort_by_best
  end

  private

  def push_answer
    return if @answer.errors.any?

    ActionCable.server.broadcast("answers:#{@answer.question_id}", ApplicationController.render(
      partial: 'answers/non-author-answer',
      locals: { answer: @answer, current_user: current_user, comment: comment }
    ))
  end

  def comment
    answer.comments.new
  end

  def answer
    @answer ||= params[:id] ? Answer.with_attached_files.find(params[:id]) : question.answers.new
  end

  helper_method :answer, :question, :comment

  def question
    @question ||= params[:question_id] ? Question.find(params[:question_id]) : nil
  end

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: %i[name url id])
  end
end
