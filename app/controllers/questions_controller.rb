class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :author_actions, only: [:edit, :update, :destroy]
  def index
    @questions = Question.all
  end

  def show
  end

  def new
  end

  def create
    @question = current_user.questions.new(question_params)

    if @question.save
      redirect_to @question, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def update
    question.update(question_params)
  end

  def destroy
    question.destroy
    redirect_to questions_path, notice: 'Your question successfully deleted.' 
  end

  private

  def author_actions
    unless current_user.author?(question)
      redirect_to questions_path, notice: "Can't perfom such action"
    end
  end

  def question
    @question ||= params[:id] ? Question.find(params[:id]) : current_user.questions.new
  end

  def answer
    question.answers.new
  end

  helper_method :question, :answer

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
