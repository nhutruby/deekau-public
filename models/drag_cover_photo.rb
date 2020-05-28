class DragCoverPhoto
  include Mongoid::Document
  mount_uploader :drag_cover_photo, DragCoverPhotoUploader
  field :average_geometry, type: Array
  field :small_257_width_geometry, type: Array
  field :small_257_height_geometry, type: Array
  embedded_in :cover_photo
  def real
    self.drag_cover_photo.url.to_s
  end
  def average
    self.drag_cover_photo.average.to_s
  end
  def small_257_width
    self.drag_cover_photo.small_257_width.to_s
  end
  def small_257_height
    self.drag_cover_photo.small_257_height.to_s
  end
  def serializable_hash(options={})
    super(options.reverse_merge(:methods => [:small_257_width, :small_257_height, :average, :real, :average_geometry, :small_257_width_geometry, :small_257_height_geometry], :except => [:drag_cover_photo, :id]))
  end
end
