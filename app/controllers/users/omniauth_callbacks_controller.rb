class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def vkontakte
    social_sign_in('Vkontakte')
  end

  def github
    social_sign_in('Github')
  end

  def set_email
  end

  def verified_oauth
    @user = User.create(password: Devise.friendly_token[0, 20], email: params[:email], uid: session[:uid], provider: session[:provider])
    if @user.persisted?
      redirect_to root_path, notice: 'A message with a confirmation link has been sent to your email address. Please follow the link to activate your account.'
    else
      render :set_email
    end
  end

  def failure
    redirect_to root_path, alert: 'Error has occured'
  end

  private

  def social_sign_in(kind)
    auth = request.env['omniauth.auth']
    user = User.from_omniauth(auth)

    if user == 'has no email'
      session[:uid] = auth.uid
      session[:provider] = auth.provider
      redirect_to set_email_path, notice: "You haven't provided email"
    elsif user&.persisted?
      sign_in_and_redirect user, event: :authentication
      set_flash_message(:notice, :success, kind: kind) if is_navigational_format?
    else
      redirect_to new_user_registration_url
    end
  end
end
