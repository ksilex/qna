class CommentsController < ApplicationController
  before_action :authenticate_user!
  # after_action :push_comment, only: :create

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
    @comment ||= params[:id] ? Comment.find(params[:id]) : question.comments.new
  end

  helper_method :comment, :resource

  def push_comment
    return if @comment.errors.any?

    ActionCable.server.broadcast(
      "comments:#{@comment.question_id}", ApplicationController.render(
        partial: 'comments/comment',
        locals: { comment: @comment, current_user: current_user }
      )
    )
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
