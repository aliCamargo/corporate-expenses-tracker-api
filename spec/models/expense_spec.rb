require 'rails_helper'

RSpec.describe Expense, type: :model do
  before { @expense = FactoryGirl.build(:expense) }

  it 'is valid with a name, trip and value' do
    expect(@expense).to be_valid
  end

  it 'is invalid without name' do
    @expense.name = nil
    @expense.valid?
    expect( @expense.errors[:name] ).to include('can\'t be blank')
  end

  it 'is invalid without trip_id' do
    @expense.trip_id = nil
    @expense.valid?
    expect( @expense.errors[:trip_id] ).to include('can\'t be blank')
  end

  it 'is invalid if trip not is started' do
    trip = FactoryGirl.create :trip, status: 'finished'

    @expense.trip_id = trip.id
    @expense.valid?
    expect( @expense.errors[:trip] ).to include('is not started')
  end

  it 'is invalid without value' do
    @expense.value = nil
    @expense.valid?
    expect( @expense.errors[:value] ).to include('can\'t be blank')
  end

  it 'is invalid if value is less or equal to zero' do
    @expense.value = 0
    @expense.valid?
    expect(@expense.errors[:value]).to include('must be greater than 0')
  end
end
