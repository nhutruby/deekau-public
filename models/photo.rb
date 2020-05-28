require 'aws-sdk'
class Photo
  include Mongoid::Document
  mount_uploader :photo, PhotoUploader
  field :large_geometry, type: Array
  field :average_geometry, type: Array
  field :small_257_width_geometry, type: Array
  field :small_257_height_geometry, type: Array
  field :small_172_width_geometry, type: Array
  field :small_172_height_geometry, type: Array
  field :small_geometry, type: Array
  belongs_to :offer
  belongs_to :business

  def to_jq_upload
    {
        'id' => id.to_s,
        'size' => photo.size,
        'url' => photo.small.url,
        'delete_url' => id.to_s
    }
  end
  def average
    self.photo.average.to_s
  end
  def large
    self.photo.large.to_s
  end
  def small
    self.photo.small.to_s
  end
  def real
    self.photo.url.to_s
  end
  def small_257_width
    self.photo.small_257_width.to_s
  end
  def small_257_height
    self.photo.small_257_height.to_s
  end
  def small_172_width
    self.photo.small_172_width.to_s
  end
  def small_172_height
    self.photo.small_172_height.to_s
  end
  def serializable_hash(options={})
    super(options.reverse_merge(:methods => [:small_172_width, :small_172_height, :small_257_width, :small_257_height, :average, :large, :real, :average_geometry, :small_257_width_geometry, :small_257_height_geometry, :small_172_width_geometry, :small_172_height_geometry, :id], :except => :photo))
  end
end
