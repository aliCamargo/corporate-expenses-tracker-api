class TripSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :budget, :status
  has_one :user
end