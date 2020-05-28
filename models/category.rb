class Category
  include Mongoid::Document


  field :name,    :type => String, localize: true
  field :description,    :type => String, localize: true
  field :css, :type => String
  field :count, :type => Integer, :default => 0

  ## Validation
  validates :name, uniqueness: true
  validates :css, uniqueness: true
  validates :name, presence: true
  validates :css, presence: true

  ## Association
  has_many :businesses
  has_many :offers
  has_many :addresses
end
