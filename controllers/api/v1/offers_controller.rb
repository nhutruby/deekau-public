class Api::V1::OffersController < ApplicationController
  before_action :authenticate_with_token!
  respond_to :json

  def create
    offer = Offer.new(offer_params)
    current_user.business.offers << offer
    current_user.update_attributes(:last_coordinates => current_user.business.addresses.first.coordinates)
    offer.photos << Photo.in(:id => params[:offer][:photo_ids]) if params[:offer][:photo_ids]
    offer.business.addresses.each do |address|
      address.update_attributes(:category_id => params[:offer][:category])
    end
    if offer.save
      offer = offer.as_json(:only => [:address, :coordinates, :_id, :created_at, :created_time, :status, :short_details], :include => { :category => {:only => [ :css, :name]}, :privacy => {:only => [:name, :css, :description]}, :photos => {:only => [:average]}, :working_time => {:except => :_id}, :business => {:only => [:name, :working_time, :slug], :methods => [:small_56_current_avatar]}})
      offer['created_time'] = Offer.set_created_time(offer['created_at'], current_user)
      offer['status'] = Offer.set_status(offer['status'])
      offer['short_details'] = Offer.set_short_details(offer['short_details'])
      render json: offer, status: 201
    else
      render json: { errors: offer.errors.full_messages().map! {|x| x + ". " } }, status: 202
    end
  end

  def get_offer
    offer = Offer.find(params[:id])
    if offer
      offer.created_time = Offer.set_created_time(offer.created_at, current_user)
      offer.address = offer.business.addresses.select{|address| address.id.to_s == params[:address_id].to_s}.last.as_json(:only => [:address])
    end
    render :json => offer.as_json(:only => [:_id, :status, :short_details, :created_time, :address], :include => {:category => {:only => [ :css, :name]}, :privacy => {:only => [:name, :css, :description]}, :business => {:only => [:name, :working_time, :slug]}, :working_time => {:except => :_id}})
  end

  def search
    offers = Offer.get_offers(params[:lnglat], params[:category]).each{|v|
      v['business']['current_offer']['created_time'] = Offer.set_created_time(v['business']['current_offer']['created_at'], current_user)
      v['business']['current_offer']['status'] = Offer.set_status(v['business']['current_offer']['status'])
      v['business']['current_offer']['short_details'] = Offer.set_short_details(v['business']['current_offer']['short_details'])
    }
    render :json => offers
  end
  private

  def offer_params
    params.require(:offer).permit(:status, :privacy, :category, :photo_ids => [], :short_details =>  [:name , :value, {:value => []}, :format],
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

end
