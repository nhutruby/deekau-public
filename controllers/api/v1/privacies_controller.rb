class Api::V1::PrivaciesController < ApplicationController
  before_action :authenticate_with_token!
  def index
    privacies = Privacy.all
    render :json => privacies
  end

end
