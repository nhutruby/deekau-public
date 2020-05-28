class PrivacySetting
  include Mongoid::Document
  extend Enumerize

  field :business_list
  field :friend_list

  enumerize :business_list, in: [:public, :societies, :businesses, :friends, :only_me], default: :public
  enumerize :friend_list, in: [:public, :societies, :businesses, :friends, :only_me], default: :public

  embedded_in :user
end

