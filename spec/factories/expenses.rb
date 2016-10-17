FactoryGirl.define do
  factory :expense do
    name          { Faker::Beer.name }
    value         { Faker::Number.decimal(2, 1) }
    note          { Faker::ChuckNorris.fact }
    trip_id       { (FactoryGirl.create :trip, status: 'started').id }
  end
end
