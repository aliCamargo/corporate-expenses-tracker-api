require 'rails_helper'

RSpec.describe Trip, type: :model do
  before { @trip = FactoryGirl.build(:trip) }

  it 'is valid with a name, user and budget' do
    expect(@trip).to be_valid
  end

  it 'is invalid without name' do
    @trip.name = nil
    @trip.valid?
    expect( @trip.errors[:name] ).to include('can\'t be blank')
  end

  it 'is invalid without user_id' do
    @trip.user_id = nil
    @trip.valid?
    expect( @trip.errors[:user_id] ).to include('can\'t be blank')
  end

  it 'is invalid with user role admin' do
    user = FactoryGirl.create :user, role: 'admin'
    @trip.user_id = user.id
    @trip.valid?
    expect( @trip.errors[:user] ).to include("role can't be #{user.role}")
  end

  it 'is invalid if user has started trip' do
    user = FactoryGirl.create :user, role: 'employee'
    trip = FactoryGirl.create :trip, user_id: user.id, status: 'started'

    @trip.user_id = user.id
    @trip.valid?
    expect( @trip.errors[:user] ).to include('has already a started trip')
  end

  it 'is invalid without budget' do
    @trip.budget = nil
    @trip.valid?
    expect( @trip.errors[:budget] ).to include('can\'t be blank')
  end

  it 'is invalid if budget is less or equal to zero' do
    @trip.budget = 0
    @trip.valid?
    expect(@trip.errors[:budget]).to include('must be greater than 0')
  end
end
