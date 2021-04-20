class SubscriptionsController < ApplicationController
  before_action :authenticate_user!

  def create
    current_user.subscriptions.create(question: question)
    redirect_to question, notice: 'You will get notifications about new answers'
  end

  def destroy
    subscription.destroy
    redirect_to subscription.question, notice: 'Unsubscribed successfully'
  end

  private

  def subscription
    @subscription ||= Subscription.find(params[:id])
  end

  def question
    @question ||= Question.find(params[:question_id])
  end
end
