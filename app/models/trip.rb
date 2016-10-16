class Trip < ApplicationRecord
  belongs_to :user

  enum status: { started: 0, finished: 1 }

  validates :user_id, :name, :budget, presence: true
  validates :budget, numericality: { greater_than: 0 }
  validates :user, employee: true, single_started: true

end
