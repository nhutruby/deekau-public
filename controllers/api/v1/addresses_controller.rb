class Api::V1::AddressesController < ApplicationController
  include Language
  before_action :authenticate_with_token!

  def search
    params[:formatted_address] = set_language(params[:formatted_address])
    params[:formatted_address].present? ? addresses = Address.where(:formatted_address => /.*#{params[:formatted_address]}.*/i).order_by(:count.desc).limit(10) : addresses = Address.all.limit(10)
    render :json => addresses
  end
end
