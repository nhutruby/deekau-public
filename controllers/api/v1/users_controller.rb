class Api::V1::UsersController < ApplicationController
  include IpCoordinates
  before_action :authenticate_with_token!, :except => [:create]
  respond_to :json

  def me
    respond_with current_user
  end

  def create
    user = User.new(user_params)
    user.last_coordinates = ip_coordinates(request)
    user.generate_token(:auth_token)
    if user.save
      render json: user, status: 201, location: [:api, user]
    else
      render json: { errors: user.errors.full_messages() }, status: 202
    end
  end

  def update
    user = current_user
    if user.update(user_params)
      render json: user, status: 200, location: [:api, user]
    else
      render json: { errors: user.errors.full_messages() }, status: 422
    end
  end
  def set_privacy
    user = current_user
    if user.update_attributes(:privacy => params[:id])
      head 204
    else
      render json: { errors: user.errors.full_messages() }, status: 422
    end
  end
  def set_last_coordinates
    user = current_user
    if user.update_attributes(:last_coordinates => params[:last_coordinates])
      head 204
    else
      render json: { errors: user.errors.full_messages() }, status: 422
    end
  end
  def destroy
    current_user.destroy
    head 204
  end
  def find
    out_people_ids = [current_user.id]
    out_people_ids.concat(Society.only(:user_id).where(:to_id => current_user.id).map(&:user_id))
    out_people_ids.concat(current_user.societies.only(:to_id).map(&:to_id))
    people = User.where('$or' => [ {:first_name => /#{Regexp.escape(params[:name])}/i},{:last_name => /#{Regexp.escape(params[:name])}/i}]).not_in(:_id => out_people_ids)
    people = people.where({:business.exists => true} ) if params[:business] == 'true' and params[:friend] == nil
    people = people.where({:business.exists => false} ) if params[:friend] == 'true' and params[:business] == nil
    people = people.page(params[:page]).per(20)
    render :json => people.as_json(:only => [:first_name, :last_name, :_id], :methods => [:slug], :include => {:business => {:only => [:name, :slug], :include => {:category => {:only => [:css]}}}})
  end
  private

  def user_params
    params.require(:user).permit(:email, :password, :first_name, :last_name)
  end

end
