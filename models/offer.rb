require 'action_view'
require 'tzinfo'
class Offer
  class DateHelper
    include ActionView::Helpers::DateHelper
  end
  def self.helper
    @h ||= DateHelper.new
  end
  include Mongoid::Document
  include Mongoid::Timestamps
  field :status, :type => String
  field :short_details, :type => Array
  field :created_time
  field :address

  ## Validation
  validates :status, presence: true
  validates_length_of :status, :maximum => 100000, :allow_blank => false
  ## Association
  embeds_one :working_time
  accepts_nested_attributes_for :working_time
  belongs_to :privacy
  belongs_to :business
  belongs_to :category
  has_many :photos
  def self.set_created_time(created_at, current_user)
    from_time = Time.now
    distance = from_time.to_i - created_at.to_i
    if distance <= 86400
      helper.distance_of_time_in_words(from_time, created_at)
    else
      tz = TZInfo::Timezone.get(current_user.time_zone)
      I18n.l tz.utc_to_local(created_at), format: :created_time
    end
  end
  def self.set_status(status)
    if status.length <= 500
      [1, status]
    elsif status.length > 500 and status.length < 2000
      [2, status]
    else
      [3, status[0..499].gsub(/\s\w+\s*$/,'...')]
    end
  end
  def self.set_short_details(short_details)
    length = short_details.length if short_details.present?
    if length
      if length <= 5
      [1, short_details]
      elsif length > 5 and length < 30
      [2, short_details]
      else
        [3, short_details[0...4]]
      end
    end
  end
  def self.get_offers(coordinates, category)
    addresses = Address.where(:coordinates => {"$near" => [coordinates[0].to_f, coordinates[1].to_f], "$maxDistance" => 1.fdiv(111.12)}).where(:category.exists => true)
    addresses = addresses.where(:category => category) if category.present?
    return addresses.limit(50).as_json(:only => [:address, :coordinates, :_id], :include => { :business => {:only => [:name, :working_time, :current_offer, :slug], :methods => [:small_56_current_avatar]}})
  end
  def reset(current_user)
    self.created_time = Offer.set_created_time(self.created_at, current_user)
    self[:status] = Offer.set_status(self.status)
    self.short_details = Offer.set_short_details(self.short_details)
    self
  end
end
