require 'rails_helper'

RSpec.describe Tag, type: :model do
  before { @tag = FactoryGirl.build(:tag) }

  it 'is valid with a name' do
    expect(@tag).to be_valid
  end

  it 'is invalid without name' do
    @tag.name = nil
    @tag.valid?
    expect( @tag.errors[:name] ).to include('can\'t be blank')
  end

  it 'is invalid if name has already been taken' do
    FactoryGirl.create(:tag, name: 'same-name' )
    @tag.name = 'same-name'
    @tag.valid?
    expect( @tag.errors[:name] ).to include('has already been taken')
  end

end
