class UserSerializer < ActiveModel::Serializer
  attributes :id, :registered_by, :email, :first_name, :last_name, :short_name, :device_token,
             :status, :date_birth, :age, :gender, :console_type, :gamer_tag, :psn_id

  has_one :country
  has_one :state
  has_one :city

  def token
    TokenService.encode( { access_token: object.access_token } )
  end
end