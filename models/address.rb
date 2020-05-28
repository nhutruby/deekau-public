class Address
  include Mongoid::Document

  field :is_primary, type: Boolean
  field :address, :type => String
  field :formatted_address, :type => String
  field :city, :type => String
  field :postal_code, :type => String
  field :country, :type => String
  field :coordinates, :type => Array

  ## Validation
  validates :address, presence: true
  validates :formatted_address, presence: true
  validates :formatted_address, uniqueness: true
  validates :coordinates, presence: true
  validates :coordinates, uniqueness: true

  ## Association
  belongs_to :business
  belongs_to :category
  index({ coordinates: "2d" },{ min: -180, max: 180, background: true })
end
