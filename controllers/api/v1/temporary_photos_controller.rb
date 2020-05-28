class Api::V1::TemporaryPhotosController < ApplicationController
  before_action :authenticate_with_token!
  respond_to :json
  def create
    temporary_photo = TemporaryPhoto.new(temporary_photo_params)
    if temporary_photo.save
      current_user.business.temporary_photo = temporary_photo
      render json: temporary_photo.to_jq_upload, status: 201
    else
      render json: { errors: temporary_photo.errors.full_messages().map! {|x| x + ". " } }, status: 202
    end
  end

  def destroy
    temporary_photo = current_user.business.temporary_photo
    if temporary_photo
      temporary_photo.destroy
    end
    head 204
  end

  private
  def temporary_photo_params
    params.require(:file).permit(:temporary_photo)
  end
end
