class Api::V1::CoverPhotosController < ApplicationController
  include ImageData
  before_action :authenticate_with_token!
  respond_to :json
  def create
    cover_photo = CoverPhoto.new(cover_photo_params)
    if cover_photo.save
      current_user.business.cover_photos << cover_photo
      render json: cover_photo.to_jq_upload, status: 201
    else
      render json: { errors: cover_photo.errors.full_messages().map! {|x| x + ". " } }, status: 202
    end
  rescue => e
    render json: { errors: e.to_s}, status: 202
  end
  def update
    cover_photo = CoverPhoto.find(params[:id])
    if cover_photo.present?
      if cover_photo.update_attributes(:drag_cover_photo => DragCoverPhoto.new(drag_cover_photo_params))
        render json: cover_photo.as_json(:only => [:_id], :methods => [], :include => {:drag_cover_photo => {:methods => [:real], :only => [:real]}}), status: 201
      else
        render json: { errors: cover_photo.errors.full_messages() }, status: 422
      end
    else
      head 404
    end
  ensure
    clean_tempfile
  end
  def destroy
    cover_photo = current_user.business.cover_photos.find(params[:id])
    if cover_photo
      cover_photo.destroy
    end
    head 204
  end

  private
  def cover_photo_params
    params.require(:file).permit(:cover_photo)
  end
  def drag_cover_photo_params
    the_params = params.require(:cover_photo).permit(:drag_cover_photo)
    the_params[:drag_cover_photo] = parse_image_data(the_params[:drag_cover_photo]) if the_params[:drag_cover_photo]
    the_params
  end
end
