class AnswersController < ApplicationController
  include VotingFeatureForControllers

  before_action :authenticate_user!
  before_action :author_actions, only: [:edit, :update, :destroy]
  after_action :dummy, only: :create

  def dummy
    ActionCable.server.broadcast("answers:#{@answer.question_id}", ApplicationController.render(
      partial: 'answers/non-author-answer',
      locals: { answer: @answer, current_user: current_user }
    ))
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
    answer.destroy
  end

  def best
    if current_user.author?(answer.question)
      answer.mark_as_best
      @reward = answer.question.reward
      @answers = answer.question.answers.sort_by_best
    else
      redirect_to root_path, notice: 'Cant perfom such action'
    end
  end

  private

  def author_actions
    unless current_user.author?(answer)
      redirect_to root_path, notice: 'Cant perfom such action'
    end
  end

  def answer
    @answer ||= params[:id] ? Answer.with_attached_files.find(params[:id]) : question.answers.new
  end

  helper_method :answer, :question

  def question
    @question ||= params[:question_id] ? Question.find(params[:question_id]) : nil
  end

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: %i[name url id])
  end
end
