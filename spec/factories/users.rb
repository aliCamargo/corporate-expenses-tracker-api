FactoryGirl.define do
  factory :user do
    first_name              { Faker::Name.first_name }
    last_name               { Faker::Name.last_name }
    phone                   { Faker::PhoneNumber.cell_phone }
    address                 { Faker::Address.street_address }
    role                    { User.roles.keys.sample }
    gender                  { User.genders.keys.sample }
    email                   { Faker::Internet.email }
    password                "12345678"
    password_confirmation   "12345678"
    access_token            { Devise.friendly_token }
  end
end
