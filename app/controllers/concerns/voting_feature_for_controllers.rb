module VotingFeatureForControllers
  extend ActiveSupport::Concern

  def upvote
    authorize! :upvote, resource
    resource.votes.create(user_id: current_user.id, vote_type: :upvote)
    json_response('upvote')
  end

  def downvote
    authorize! :downvote, resource
    resource.votes.create(user_id: current_user.id, vote_type: :downvote)
    json_response('downvote')
  end

  def unvote
    authorize! :unvote, resource
    resource.votes.find_by(user_id: current_user.id)&.destroy
    json_response('unvote')
  end

  private

  def resource_errors(vote, resource)
    render json: {
      errors: vote.errors.full_messages,
      resource: resource.model_name.singular,
      resource_id: resource.id
    }, status: :unprocessable_entity
  end

  def json_response(vote_type)
    render json: {
      resource: resource.model_name.singular,
      resource_id: resource.id,
      vote_type: vote_type,
      sum: resource.votes.summarize
    }
  end

  def resource
    controller_name.classify.constantize.find(params[:id])
  end
end
