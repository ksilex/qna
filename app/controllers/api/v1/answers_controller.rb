class Api::V1::AnswersController < Api::V1::BaseController
  def index
    render json: Question.find(params[:question_id]).answers
  end

  def show
    render json: Answer.find(params[:id]), serializer: SingleAnswerSerializer
  end
end
