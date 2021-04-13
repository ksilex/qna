class Api::V1::AnswersController < Api::V1::BaseController

  def index
    render json: question.answers
  end

  def show
    render json: answer, serializer: SingleAnswerSerializer
  end

  def create
    @answer = question.answers.new(answer_params)
    @answer.user = current_user
    if @answer.save
      render json: @answer
    else
      render json: { errors: @answer.errors.full_messages }
    end
  end

  def update
    authorize! :update, answer
    answer.update(answer_params)
  end

  def destroy
    authorize! :destroy, answer
    answer.destroy
  end

  private

  def answer_params
    params.permit(:body)
  end

  def question
    @question ||= Question.find(params[:question_id])
  end

  def answer
    @answer ||= Answer.find(params[:id])
  end
end
