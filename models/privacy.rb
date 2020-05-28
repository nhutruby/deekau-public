class Privacy
  include Mongoid::Document
  field :name, :type => String, localize: true
  field :description, :type => String, localize: true
  field :css, :type => String

  validates :name, uniqueness: true
  validates :name, presence: true

  has_many :users
  has_many :offers
end
