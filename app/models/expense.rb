class Expense < ApplicationRecord
  belongs_to :trip

  validates :name, :value, :trip_id, presence: true
  validates :value, numericality: { greater_than: 0 }
  validates :trip, started: true
end
