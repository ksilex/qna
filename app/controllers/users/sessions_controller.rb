# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]
  before_action :authenticate_user!, only: %i[profile subscribe_to_question unsubscribe_from_question]

  def profile
    @rewards = current_user.rewards
  end

  def subscribe_to_question
    current_user.subscriptions.create(question: question)
    redirect_to question, notice: 'You will get notifications about new answers'
  end

  def unsubscribe_from_question
    current_user.subscriptions.find_by(question: question)&.destroy
    redirect_to question, notice: 'Unsubscribed successfully'
  end

  private

  def question
    @question ||= Question.find(params[:question_id])
  end

  def authenticate_user!
    redirect_to new_user_session_path, alert: 'You need to sign in or sign up before continuing.' unless current_user
  end
  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
