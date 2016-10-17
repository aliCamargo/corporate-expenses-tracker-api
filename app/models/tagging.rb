class Tagging < ApplicationRecord
  belongs_to :tag
  belongs_to :expense

  validates :tag, :expense, presence: true
  validates :tag, uniqueness: { scope: :expense,
                                      message: 'should happen once per expense' }
end
