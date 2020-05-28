class WorkingTime
  include Mongoid::Document

  field :mon_open, :type => Boolean
  field :tue_open, :type => Boolean
  field :wed_open, :type => Boolean
  field :thu_open, :type => Boolean
  field :fri_open, :type => Boolean
  field :sat_open, :type => Boolean
  field :sun_open, :type => Boolean

  field :mon_from, :type => String
  field :mon_to, :type => String

  field :tue_from, :type => String
  field :tue_to, :type => String

  field :wed_from, :type => String
  field :wed_to, :type => String

  field :thu_from, :type => String
  field :thu_to, :type => String

  field :fri_from, :type => String
  field :fri_to, :type => String

  field :sat_from, :type => String
  field :sat_to, :type => String

  field :sun_from, :type => String
  field :sun_to, :type => String

  ## Association
  embedded_in :business
  embedded_in :offer

end