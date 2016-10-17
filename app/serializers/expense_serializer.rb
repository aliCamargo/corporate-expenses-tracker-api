class ExpenseSerializer < ActiveModel::Serializer
  attributes :id, :name, :note, :value
  has_one :trip
end