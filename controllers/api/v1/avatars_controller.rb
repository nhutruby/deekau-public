class Api::V1::AvatarsController < ApplicationController
  include ImageData
  before_action :authenticate_with_token!
  respond_to :json
  def create
    avatar = Avatar.new(avatar_params)
    if avatar.save
      current_user.business.avatars << avatar
      temporary_photo = current_user.business.temporary_photo
      temporary_photo.destroy if temporary_photo
      render json: avatar.to_jq_upload, status: 201
    else
      render json: { errors: avatar.errors.full_messages().map! {|x| x + ". " } }, status: 202
    end
  ensure
    clean_tempfile
  end

  def destroy
    avatar = current_user.business.avatars.find(params[:id])
    if avatar
      avatar.destroy
    end
    head 204
  end
  private
  def avatar_params
    the_params = params.require(:file).permit(:avatar)
    the_params[:avatar] = parse_image_data(the_params[:avatar]) if the_params[:avatar]
    the_params
  end
end