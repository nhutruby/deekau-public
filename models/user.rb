class User
  include Mongoid::Document
  include Mongoid::Slug
  # Include default devise modules. Others available are:
  # :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable, :omniauthable, :lockable

  ## Database authenticatable
  field :email,              type: String, default: ""
  field :encrypted_password, type: String, default: ""

  ## Recoverable
  field :reset_password_token,   type: String
  field :reset_password_sent_at, type: Time

  ## Rememberable
  field :remember_created_at, type: Time

  ## Trackable
  field :sign_in_count,      type: Integer, default: 0
  field :current_sign_in_at, type: Time
  field :last_sign_in_at,    type: Time
  field :current_sign_in_ip, type: String
  field :last_sign_in_ip,    type: String

  ## Confirmable
  field :confirmation_token,   type: String
  field :confirmed_at,         type: Time
  field :confirmation_sent_at, type: Time
  field :unconfirmed_email,    type: String # Only if using reconfirmable

  ## Lockable
  field :failed_attempts, type: Integer, default: 0 # Only if lock strategy is :failed_attempts
  field :unlock_token,    type: String # Only if unlock strategy is :email or :both
  field :locked_at,       type: Time

  ## More
  field :auth_token, type: String
  field :first_name, type: String
  field :last_name, type: String
  field :last_coordinates, type: Array
  field :time_zone, type: String
  slug :first_name, :last_name do |doc|
    [ doc.first_name.delete(' '), doc.last_name.delete(' ') ].compact.join(" ").to_url
  end
  ## Association
  has_many :authentications
  has_many :societies
  belongs_to :business
  belongs_to :privacy
  embeds_one :privacy_setting
  accepts_nested_attributes_for :authentications

  validates :auth_token, uniqueness: true
  # validates :confirmation_token, uniqueness: true
  validates :first_name, presence: true
  validates :last_name, presence: true

  # before_validation :generate_auth_token!
  before_create :set_time_zone
  before_create :set_privacy_setting
  after_initialize do |user|
    self.privacy ||= Privacy.find_by(:css => 'web')
  end
  def self.authenticate!(email, password)
    user = User.where(email: email).first
    return (user.valid_password?(password) ? user : nil) unless user.nil?
    nil
  end
  def generate_token(column)
    begin
      self[column] = SecureRandom.hex(64)
    end while User.find_by(column => self[column])
  end

  def generate_auth_token!
    begin
      self.auth_token = SecureRandom.hex(64)
    end while User.find_by(auth_token: self.auth_token)
  end

  def send_password_reset
    self.generate_token(:reset_password_token)
    self.reset_password_sent_at = Time.zone.now
    save!
    UserMailer.reset_password(self.reset_password_token, self.email, self.first_name, self.last_name).deliver_now
  end
  def apply_omniauth(omni)
    authentications.build(:provider => omni['provider'],
                          :uid => omni['uid'],
                          :token => omni['credentials'].token,
                          :token_secret => omni['credentials'].secret)
  end
  class << self
    def status_with_current_user(from_id, current_user)
      received_society = Society.find_by(:user_id => from_id, :to_id => current_user.id)
      if received_society == nil
        sent_society = Society.find_by(:user_id => current_user.id, :to_id => from_id)
        if sent_society == nil
          return {:status => 'add'}
        else
          return {:status => 'sent', :id => sent_society.id, :category => sent_society.category}
        end
      else
        if received_society.status == 0
          return received_society.category == 0 ? {:status => 'received_friend', :id => received_society.id, :category => received_society.category} : {:status => 'received_business', :id => received_society.id, :category => received_society.category}
        else
          return received_society.category == 0 ? {:status => 'friend', :id => received_society.id} : {:status => 'business', :id => received_society.id}
        end
      end
    end
    def check_save(user)
      if user.save
        user
      else
        nil
      end
    end
    def auth(omni, last_coordinates)
      omni['provider'] == 'facebook' ? @token = omni['credentials'].token : @token = omni['credentials'].refresh_token
      last_name = omni['info'].last_name
      first_name = omni['info'].first_name
      email = omni['info'].email
      user = User.find_by(:email => email)
      if user.present?
        authentication = Authentication.find_by(:provider => omni['provider'],:uid  => omni['uid'])
        if authentication.present?
          user
        else
          user.apply_omniauth(omni)
          check_save(user)
        end
      else
        password = Devise.friendly_token[0,20]
        user = User.new(:last_name => last_name,:first_name => first_name, :email => email, :password => password)
        user.last_coordinates = last_coordinates
        user.skip_confirmation!
        user.generate_token(:auth_token)
        user.apply_omniauth(omni)
        check_save(user)
      end
    end
  end

  private

  def set_time_zone
    timezone = Timezone.lookup(self.last_coordinates[1], self.last_coordinates[0])
    self.time_zone = timezone.zone
  end
  def set_privacy_setting
    self.privacy_setting = PrivacySetting.new()
  end
end
