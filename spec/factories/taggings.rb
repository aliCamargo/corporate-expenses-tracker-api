FactoryGirl.define do
  factory :tagging do
    tag       { FactoryGirl.create :tag }
    expense   { FactoryGirl.create :expense }
  end
end
