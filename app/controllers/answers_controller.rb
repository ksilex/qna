class AnswersController < ApplicationController
  before_action :authenticate_user!

  def create
    @answer = question.answers.new(answer_params)
    @answer.user = current_user
    if @answer.save
      redirect_to @answer.question, notice: 'Your answer successfully created.'
    else
      render 'questions/show'
    end
  end

  def edit
  end

  def update
    if answer.update(answer_params)
      redirect_to answer.question
    else
      render :edit
    end
  end

  def destroy
    if current_user.author?(answer)
      answer.destroy
      redirect_to answer.question, notice: 'Your answer successfully deleted.'
    end
  end

  private

  def answer
    @answer ||= params[:id] ? Answer.find(params[:id]) : question.answers.new
  end

  helper_method :answer, :question

  def question
    @question ||= Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
