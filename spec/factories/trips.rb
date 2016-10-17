FactoryGirl.define do
  factory :trip do
    user_id       { (FactoryGirl.create :user, role: 'employee').id }
    name          { Faker::Name.first_name }
    description   { Faker::Hipster.sentence }
    budget        { Faker::Number.decimal(3, 2) }
    status        { Trip.statuses.keys.sample }
  end
end
