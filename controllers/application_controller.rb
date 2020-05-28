require 'online'
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session
  include Authenticable
  skip_before_action :verify_authenticity_token, if: :json_request?
  before_action :set_locale
  before_action :track_online_users
  def set_locale
    I18n.locale = cookies[:locale] || I18n.default_locale
  end
  def track_online_users
    if current_user.present?
      online = Online.new($redis)
      puts online
      puts current_user.id
      online.track(current_user.id)
    end
  end
  def default_serializer_options
    {root: false}
  end
  protected

  def json_request?
    request.format.json?
  end


end
