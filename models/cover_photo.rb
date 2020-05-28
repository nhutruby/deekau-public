require 'file_size_validator'
class CoverPhoto
  include Mongoid::Document
  mount_uploader :cover_photo, CoverPhotoUploader
  field :large_geometry, type: Array
  belongs_to :business
  embeds_one :drag_cover_photo, cascade_callbacks: true
  validates :cover_photo,
            :presence => true,
            :file_size => {
                :maximum => 4.megabytes.to_i
            }
  validate :validate_minimum_image_size, :on => :create

  def validate_minimum_image_size
    image = MiniMagick::Image.open(cover_photo.path)
    unless image[:width] > 300 && image[:height] > 150
      errors.add :base, I18n.t('errors.models.cover_photo.attributes.cover_photo.minimum_image_size')
    end
  end
  def to_jq_upload
    {
        'id' => id.to_s,
        'size' => cover_photo.size,
        'url' => cover_photo.large.url,
        'delete_url' => id.to_s
    }
  end
  def large
    self.cover_photo.large.to_s
  end
  def real
    self.cover_photo.url.to_s
  end
  def serializable_hash(options={})
    super(options.reverse_merge(:methods => [:large, :real, :id], :except => :cover_photo))
  end
end
