class UserSerializer < ActiveModel::Serializer
  attributes :id, :token, :email, :first_name, :last_name
  has_many :roles

  def token
    options[:token]
  end
end
