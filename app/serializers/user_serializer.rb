class UserSerializer < ActiveModel::Serializer
  attributes :id, :token, :email, :first_name, :last_name

  def token
    options[:token]
  end
end
