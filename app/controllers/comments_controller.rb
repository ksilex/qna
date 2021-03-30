class CommentsController < ApplicationController
  before_action :authenticate_user!
  after_action :push_comment, only: :create

  def create
    @comment = resource.comments.new(comment_params)
    @comment.user = current_user
    @comment.save
  end

  private

  def resource
    @resource = params[:answer_id] ? Answer.find(params[:answer_id]) : Question.find(params[:question_id])
  end

  def comment
    @comment ||= resource.comments.new
  end

  helper_method :comment, :resource

  def push_comment
    return if @comment.errors.any?

    question_id = resource.class == Answer ? resource.question.id : resource.id
    ActionCable.server.broadcast(
      "comments:#{question_id}", ApplicationController.render(
        partial: 'comments/non-author-comment',
        locals: { comment: @comment, current_user: current_user, resource: resource.model_name.singular }
      )
    )
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
