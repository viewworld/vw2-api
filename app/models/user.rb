class User < ActiveRecord::Base
  enum role: { sysadmin: 1, admin: 2, user: 3, editor: 4 }
  before_save { self.email = email.downcase }

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

  def has_payment_info?
    organisation.braintree_customer_id
  end
end

