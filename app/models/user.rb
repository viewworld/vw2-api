class User < ActiveRecord::Base
  before_save { self.email = email.downcase }
  after_save :set_default_role

  belongs_to :group

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { in: 4..150 },
            format: { with: VALID_EMAIL_REGEX },
            uniqueness: { case_sensitive: false }

  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

  # Generates authentication token and sets it to Redis.
  def set_auth_token
    auth_token = SecureRandom.urlsafe_base64
    $redis.hset(auth_token, "#{self.class.to_s}_id", self.id)
    auth_token
  end

  ROLES = { 1 => 'sysadmin',
            2 => 'admin',
            3 => 'user',
            4 => 'editor' }.freeze

  def has_role?(role)
    true if role == ROLES[self.role]
  end

  def role
    ROLES[read_attribute(:role)]
  end
end

