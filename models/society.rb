class Society
  include Mongoid::Document

  # 0: request friend/business, 1: accept friend/business, 2: follow user
  field :status, :type => Integer

  # 0: friend, 1: business relationship
  field :category, :type => Integer
  # Association

  belongs_to :user
  belongs_to :to, :class_name => 'User'

  # Validation
  validates_uniqueness_of :user, :scope => :to
  index({ user_id: 1, to_id: 1 }, { unique: true })
end
