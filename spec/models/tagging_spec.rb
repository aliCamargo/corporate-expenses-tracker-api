require 'rails_helper'

RSpec.describe Tagging, type: :model do
  before { @tagging = FactoryGirl.build(:tagging) }

  it 'is valid with a tag and expense' do
    expect(@tagging).to be_valid
  end

  it 'is invalid without tag' do
    @tagging.tag = nil
    @tagging.valid?
    expect( @tagging.errors[:tag] ).to include('can\'t be blank')
  end

  it 'is invalid without expense' do
    @tagging.expense = nil
    @tagging.valid?
    expect( @tagging.errors[:expense] ).to include('can\'t be blank')
  end

  it 'is invalid when expense have duplicate tag' do
    FactoryGirl.create( :tagging, expense: @tagging.expense, tag: @tagging.tag )
    @tagging.valid?
    expect( @tagging.errors[:tag] ).to include('should happen once per expense')
  end
end
