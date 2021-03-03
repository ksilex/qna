class AnswersController < ApplicationController
  def new
  end

  def create
    @answer = question.answers.new(answer_params)
    if @answer.save
      redirect_to @answer.question
    else
      render :new
    end
  end

  private

  def answer
    @answer ||= params[:id] ? Answer.find(params[:id]) : question.answers.new
  end

  helper_method :answer

  def question
    @question ||= Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
