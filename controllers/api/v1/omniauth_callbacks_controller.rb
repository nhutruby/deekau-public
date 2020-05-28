class Api::V1::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  include IpCoordinates
  def facebook
    auth('Facebook')
  end
  def google_oauth2
    auth('Google')
  end
  private
  def auth(kind)
    last_coordinates = ip_coordinates(request)
    user = User.auth(request.env["omniauth.auth"], last_coordinates)
    if user.present?
      sign_in user, store: false
      cookies[:auth_token] = user.auth_token
      redirect_to root_url
    else
      cookies[:flash] = I18n.t('devise.omniauth_callbacks.failure', :kind => kind)
      redirect_to root_url
    end
  end

end