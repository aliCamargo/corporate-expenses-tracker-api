class TripSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :budget, :refund, :status
  has_one :user
  has_many :expenses
end