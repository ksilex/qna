class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def vkontakte
    auth = request.env['omniauth.auth']
    session[:uid] = auth.uid
    session[:provider] = auth.provider
    user = User.from_omniauth(auth)

    if user == 'has no email'

      redirect_to set_email_path, notice: 'You have no email'
    elsif user.persisted?
      sign_in_and_redirect @user, event: :authentication # this will throw if @user is not activated
      set_flash_message(:notice, :success, kind: 'Vkontakte') if is_navigational_format?
    else
      redirect_to new_user_registration_url
    end
  end

  def github
    auth = request.env['omniauth.auth']
    session[:uid] = auth.uid
    session[:provider] = auth.provider
    user = User.from_omniauth(auth)

    if user == 'has no email'
      redirect_to set_email_path, notice: "You haven't provided email"
    elsif user&.persisted?
      sign_in_and_redirect user, event: :authentication # this will throw if @user is not activated
      set_flash_message(:notice, :success, kind: 'Github') if is_navigational_format?
    else
      redirect_to new_user_registration_url
    end
  end

  def set_email
  end

  def verified_oauth
    @user = User.create(password: Devise.friendly_token[0, 20], email: params[:email], uid: session[:uid], provider: session[:provider])
    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication # this will throw if @user is not activated
      set_flash_message(:notice, :success, kind: 'Vkontakte') if is_navigational_format?
    else
      redirect_to new_user_registration_url
    end
  end

  def failure
    redirect_to root_path
  end
end
