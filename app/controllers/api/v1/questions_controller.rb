class Api::V1::QuestionsController < Api::V1::BaseController
  def index
    @questions = Question.all
    render json: @questions
  end

  def show
    render json: question, serializer: SingleQuestionSerializer
  end

  def create
    @question = current_user.questions.new(question_params)
    if @question.save
      render json: @question
    else
      render json: { errors: @question.errors.full_messages }
    end
  end

  def update
    authorize! :update, question
    question.update(question_params)
  end

  def destroy
    authorize! :destroy, question
    question.destroy
  end

  private

  def question_params
    params.permit(:title, :body, links_attributes: %i[name url id])
  end

  def question
    @question ||= Question.find(params[:id])
  end
end
