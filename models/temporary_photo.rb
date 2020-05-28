class TemporaryPhoto
  include Mongoid::Document
  mount_uploader :temporary_photo, TemporaryPhotoUploader
  belongs_to :business
  def to_jq_upload
    {
        'id' => id.to_s,
        'size' => temporary_photo.size,
        'url' => temporary_photo.url,
        'delete_url' => id.to_s
    }
  end
end