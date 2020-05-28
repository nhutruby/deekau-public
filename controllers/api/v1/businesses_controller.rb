class Api::V1::BusinessesController < ApplicationController
  before_action :authenticate_with_token!
  before_action :check_coordinates_cannot_be_crowded, :only => :create
  respond_to :json

  def create
    if current_user.business.nil?
      business = Business.new(business_params)
      business.addresses.build(address_params)
      if business.save
        current_user.update_attributes(:last_coordinates => params[:address][:coordinates], :business_id => business.id)
        render json: business, status: 201
      else
        render json: { errors: business.errors.full_messages().map! {|x| x + ". " } }, status: 202
      end
    else
      render json: nil
    end
  end
  def get_business
    business = Business.find_by(:slug => params[:slug])
    temporary_photo = business.temporary_photo if business
    temporary_photo.destroy if temporary_photo
    render :json => business.as_json(:only => [:_id, :name, :slug, :small_200_current_avatar, :current_cover_photo], :include => {:working_time => {:except => :_id}})
  end
  def get_offers
    business = Business.find_by(:slug => params[:slug])
    if business
      offers = business.offers.desc(:created_at).page(params[:page]).per(5)
      offers = offers.as_json(:only => [:address, :coordinates, :_id, :created_at, :created_time, :status, :short_details], :include => { :category => {:only => [ :css, :name]}, :privacy => {:only => [:name, :css, :description]}, :photos => {:only => [:average]}, :working_time => {:except => :_id}, :business => {:only => [:name, :working_time, :slug], :methods => [:small_56_current_avatar]}}).each{|v|
        v['created_time'] = Offer.set_created_time(v['created_at'], current_user)
        v['status'] = Offer.set_status(v['status'])
        v['short_details'] = Offer.set_short_details(v['short_details'])
      }
      render json: offers, status: 201
    else
      render json: nil
    end
  end
  private
  def check_coordinates_cannot_be_crowded
    if Address.where(:coordinates => {"$near" => [params[:address][:coordinates]["1"].to_f, params[:address][:coordinates]["0"].to_f], "$maxDistance" => 0.005.fdiv(111.12)}).length > 0
      render json: { errors: I18n.t("errors.models.application.attributes.coordinates.crowded") }, status: 202
    end
  end
  def business_params
    params.require(:business).permit(:name, :category, :slug,
      :working_time =>
      [
          :mon_open,
          :tue_open,
          :wed_open,
          :thu_open,
          :fri_open,
          :sat_open,
          :sun_open,
          :mon_from,
          :mon_to,
          :tue_from,
          :tue_to,
          :wed_from,
          :wed_to,
          :thu_from,
          :thu_to,
          :fri_from,
          :fri_to,
          :sat_from,
          :sat_to,
          :sun_from,
          :sun_to
      ]
    )
  end

  def address_params
    params[:address][:coordinates] = [params[:address][:coordinates]["0"].to_f, params[:address][:coordinates]["1"].to_f]
    formatted_address = Array.new
    formatted_address.push(params[:address][:address])
    formatted_address.push(params[:address][:city])
    formatted_address.push(params[:address][:long_country])
    params[:address][:formatted_address] = formatted_address * ","
    params[:address].delete(:long_country)
    params.require(:address).permit(:country, :city, :address, :formatted_address, :postal_code, :coordinates => [])
  end
end
