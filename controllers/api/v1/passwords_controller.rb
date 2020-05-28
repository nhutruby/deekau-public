class Api::V1::PasswordsController < ApplicationController
  include Recaptcha
  def create
    user = User.find_by(email: params[:email])
    if user
      user.send_password_reset
      head 204
    else
      head 202
    end
  end

  def edit
    user = User.find_by(reset_password_token: params[:id])
    if user.present?
      redirect_to '/reset-password/' + params[:id]
    else
      redirect_to '/'
    end
  end

  def update
    if verify_recaptcha(params["g-recaptcha-response"])
      user = User.find_by(reset_password_token: params[:id])
      if user.present? && user.reset_password_sent_at < 2.hours.ago
        render json: { errors: I18n.t('devise.passwords.expired') }, status: 202
      elsif user.present? && user.update_attributes(user_params)
        cookies[:flash] = I18n.t 'devise.passwords.updated_not_active'
        render json: user, status: 201, location: [:api, user]
      else
        render json: { errors: I18n.t('devise.passwords.no_token') }, status: 202
      end
    else
      render json: { errors: I18n.t('recaptcha.errors.incorrect') }, status: 202
    end
  end

  private

  def user_params
    params.require(:user).permit(:password)
  end
end
