class QuestionsController < ApplicationController
  include VotingFeatureForControllers

  before_action :authenticate_user!, except: [:index, :show]
  before_action :author_actions, only: [:edit, :update, :destroy]
  after_action :push_question, only: :create
  def index
    @questions = Question.all.order(updated_at: :desc)
  end

  def show
  end

  def create
    @question = current_user.questions.create(question_params)
  end

  def update
    question.update(question_params)
  end

  def destroy
    question.destroy
    redirect_to questions_path, notice: 'Your question successfully deleted.'
  end

  private

  def push_question
    return if @question.errors.any?

    ActionCable.server.broadcast("questions", ApplicationController.render(
      partial: 'questions/non-author-question',
      locals: { question: @question, current_user: current_user }
    ))
  end

  def author_actions
    unless current_user.author?(question)
      redirect_to questions_path, notice: "Can't perfom such action"
    end
  end

  def question
    @question ||= params[:id] ? Question.with_attached_files.find(params[:id]) : current_user.questions.new
  end

  def answer
    @answer = question.answers.new
    @answer.links.new
    @answer
  end

  def comment
    question.comments.new
  end

  helper_method :question, :answer, :comment

  def question_params
    params.require(:question).permit(:title, :body, files: [], links_attributes: %i[name url id], reward_attributes: %i[name file id])
  end
end
