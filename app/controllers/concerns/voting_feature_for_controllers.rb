module VotingFeatureForControllers
  extend ActiveSupport::Concern

  def upvote
    #authorize! :downvote, resource этот код делает с точки зрения системы то же самое что код ниже, но
    # хуже - без оповещения юзера флэш сообщением + нужно переписывать другие тесты на тот же самый функционал
    vote = resource.votes.new(user_id: current_user.id, vote_type: :upvote)
    if vote.save
      json_response('upvote')
    else
      resource_errors(vote, resource)
    end
  end

  def downvote
    #authorize! :downvote, resource
    vote = resource.votes.new(user_id: current_user.id, vote_type: :downvote)
    if vote.save
      json_response('downvote')
    else
      resource_errors(vote, resource)
    end
  end

  def unvote
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
