class Api::V1::QuestionsController < Api::V1::BaseController
  def index
    @questions = Question.all
    render json: @questions
  end

  def show
    render json: Question.find(params[:id]), serializer: SingleQuestionSerializer
  end
end
