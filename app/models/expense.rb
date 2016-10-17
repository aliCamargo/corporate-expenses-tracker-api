class Expense < ApplicationRecord
  belongs_to :trip
  has_many :taggings
  has_many :tags, through: :taggings

  validates :name, :value, :trip_id, presence: true
  validates :value, numericality: { greater_than: 0 }
  validates :trip, started: true

  def all_tags=(names)
    self.tags = names.split(',').map { |name| Tag.where(name: name.strip).first_or_create! } .uniq
  end

  def all_tags
    self.tags.map(&:name).join(', ')
  end
end
