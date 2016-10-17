class Tag < ApplicationRecord
  has_many :taggings
  has_many :expenses, through: :taggings

  validates :name, presence: true, uniqueness: true
end
