class ExpenseSerializer < ActiveModel::Serializer
  attributes :id, :name, :note, :value, :all_tags, :created_at
  has_one :trip
end