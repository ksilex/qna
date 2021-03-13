class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :author_actions, only: [:edit, :update, :destroy]

  def create
    @answer = question.answers.new(answer_params)
    @answer.user = current_user
    @answer.save
    respond_to do |format|
      format.js
    end
  end
  
  def edit
  end

  def update
    answer.update(answer_params)
  end

  def destroy
    answer.destroy
    redirect_to answer.question, notice: 'Your answer successfully deleted.'
  end

  private

  def author_actions
    unless current_user.author?(answer)
      redirect_to root_path, notice: 'Cant perfom such action' 
    end
  end

  def answer
    @answer ||= params[:id] ? Answer.find(params[:id]) : question.answers.new
  end

  helper_method :answer, :question

  def question
    @question ||= params[:question_id] ? Question.find(params[:question_id]) : nil
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
