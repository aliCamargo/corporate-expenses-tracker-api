class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :first_name, :last_name, :short_name, :full_name, :role, :gender
  has_many :trips
end