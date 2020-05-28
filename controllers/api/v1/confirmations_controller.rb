class Api::V1::ConfirmationsController < Devise::ConfirmationsController
  def show
    user = User.confirm_by_token(params[:confirmation_token])
    if user.errors.empty?
      cookies[:flash] =  I18n.t 'devise.confirmations.confirmed'
      redirect_to root_url
    else
      cookies[:flash] =  user.errors.full_messages
      redirect_to root_url
    end
  end
end
