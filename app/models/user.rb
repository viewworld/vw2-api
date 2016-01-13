class User < ActiveRecord::Base
  before_save { self.email = email.downcase }
  after_save :set_default_role

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { in: 4..150 },
            format: { with: VALID_EMAIL_REGEX },
            uniqueness: { case_sensitive: false }

  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

  def set_auth_token
    auth_token = SecureRandom.urlsafe_base64
    $redis.hset(auth_token, "#{self.class.to_s}_id", self.id)
    auth_token
  end

  def has_role?(role)
  end
end

