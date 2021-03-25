module VotingFeatureForControllers
  extend ActiveSupport::Concern

  def upvote
    resource.votes.create(user_id: current_user.id, vote_type: :upvote)
    @sum = resource.votes.summarize
  end

  def downvote
    resource.votes.create(user_id: current_user.id, vote_type: :downvote)
    @sum = resource.votes.summarize
  end

  private

  def resource
    @resource = controller_name.classify.constantize.find(params[:id])
  end
end
