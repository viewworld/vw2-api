class User < ActiveRecord::Base
  before_save { self.email = email.downcase }
  # after_save :set_default_role

  belongs_to :group
  delegate :organisation, to: :group, allow_nil: true
  delegate :forms, to: :organisation, allow_nil: true

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

  def role
    ROLES[read_attribute(:role)]
  end

  def sysadmin?
    true if self.role == 'sysadmin'
  end

  def admin?
    true if self.role == 'admin'
  end

  def user?
    true if self.role == 'user'
  end

  def editor?
    true if self.role == 'editor'
  end

  def has_payment_info?
    organisation.braintree_customer_id
  end
end

