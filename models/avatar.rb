require 'aws-sdk'
class Avatar
  include Mongoid::Document
  include Mongoid::Timestamps
  mount_uploader :avatar, AvatarUploader
  field :large_geometry, type: Array
  field :average_geometry, type: Array
  field :small_200_geometry, type: Array
  field :small_56_geometry, type: Array
  belongs_to :business
  def to_jq_upload
    {
        'id' => id.to_s,
        'size' => avatar.size,
        'url' => avatar.url,
        'delete_url' => id.to_s
    }
  end
  def real
    self.avatar.url.to_s
  end
  def large
    self.avatar.large.to_s
  end
  def average
    self.avatar.average.to_s
  end
  def small_200
    self.avatar.small_200.to_s
  end
  def small_56
    self.avatar.small_56.to_s
  end
end