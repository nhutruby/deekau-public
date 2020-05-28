class Business
  include Mongoid::Document
  field :name, :type => String
  field :slug, :type => String
  field :current_offer
  field :small_200_current_avatar
  field :small_56_current_avatar
  field :current_cover_photo
  ## Association
  has_many :addresses
  has_many :offers
  has_many :photos
  has_many :avatars
  has_many :cover_photos
  has_one :temporary_photo
  accepts_nested_attributes_for :addresses

  belongs_to :category
  has_many :users
  embeds_one :working_time

  ## Validation
  validates :name, presence: true
  validates :name, uniqueness: true
  validates :slug, presence: true
  validates :slug, uniqueness: true
  after_initialize do |business|
    self.category ||= Category.find_by(:css => 'another')
  end
  before_validation do
    if self.slug.present?
      self.slug = self.slug.downcase.tr('/\\', '')
      self.slug.gsub! /\s+/, ''
    end
  end
  def current_offer
    self.offers.order_by([:created_at, :asc]).last.as_json(:only => [:_id, :status, :short_details, :created_at], :include => {:category => {:only => [ :css, :name]}, :privacy => {:only => [:name, :css, :description]}, :photos => {:only => [:average]}, :working_time => {:except => :_id}})
  end
  def small_200_current_avatar
    self.avatars.order_by([:created_at, :asc]).last.as_json(:only => [:_id], :methods => [:small_200])
  end
  def small_56_current_avatar
    self.avatars.order_by([:created_at, :asc]).last.as_json(:only => [:_id], :methods => [:small_56])
  end
  def current_cover_photo
    self.cover_photos.where(:drag_cover_photo.exists => true).last.as_json(:only => [:_id], :methods => [], :include => {:drag_cover_photo => {:methods => [:real], :only => [:real]}})
  end
end
