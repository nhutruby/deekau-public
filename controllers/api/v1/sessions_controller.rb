class  Api::V1::SessionsController <  ApplicationController
  before_action :authenticate_with_token!, :except => [:create]
  respond_to :json

  def create
    user_password = params[:password]
    user_email = params[:email]
    user = user_email.present? && User.find_by(email: user_email)
    if user && user.valid_password?(user_password)
      #should delete the code
      if params[:remember_me] == 'true'
        cookies.permanent[:auth_token] = user.auth_token
      else
        cookies[:auth_token] = user.auth_token
      end
      #
      sign_in user, store: false
      user.generate_token(:auth_token)
      user.save
      render json: user, status: 200, location: [:api, user]
    else
      render json: { error: I18n.t('devise.failure.invalid') }, status: 202
    end
  end

  def destroy
    user = User.find_by(auth_token: params[:id])
    if user.present?
      user.generate_token(:auth_token)
      user.save
      head 204
    else
      head 404
    end
  end
end
