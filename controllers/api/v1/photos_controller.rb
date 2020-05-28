class Api::V1::PhotosController < ApplicationController
  before_action :authenticate_with_token!
  respond_to :json
  def create
    photo = Photo.new(photo_params)
    if photo.save
      current_user.business.photos << photo
      render json: photo.to_jq_upload, status: 201
    else
      render json: { errors: photo.errors.full_messages().map! {|x| x + ". " } }, status: 202
    end
  end

  def destroy
    photo = current_user.business.photos.find(params[:id])
    if photo
      photo.destroy
    end
    head 204
  end

  private
  def photo_params
    params.require(:file).permit(:photo)
  end
end
