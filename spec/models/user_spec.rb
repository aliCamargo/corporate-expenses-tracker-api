require 'rails_helper'

RSpec.describe User, type: :model do
  before { @user = FactoryGirl.build(:user) }

  it 'is valid with a email and password' do
    expect(@user).to be_valid
  end

  it 'is invalid without email' do
    @user.email = nil
    @user.valid?
    expect( @user.errors[:email] ).to include('can\'t be blank')
  end

  it 'is invalid if email has been taken' do
    existing_user = FactoryGirl.create(:user, access_token: 'unique_access_token')
    @user.email = existing_user.email
    @user.valid?
    expect(@user.errors[:email]).to include('has already been taken')
  end

  it 'is invalid without password' do
    @user.password = nil
    @user.password_confirmation = nil
    @user.valid?
    expect( @user.errors[:password] ).to include('can\'t be blank')
  end

  it 'is invalid if password is not equal to password_confirmation' do
    @user.password = '123456789'
    expect(@user).not_to be_valid
  end

  describe '#generate_access_token!' do
    it 'generates a unique access token' do
      allow(Devise).to receive(:friendly_token).and_return( 'unique_access_token' )
      @user.generate_access_token!
      expect(@user.access_token).to eql 'unique_access_token'
    end

    it 'generates another access token when one already has been taken' do
      existing_user = FactoryGirl.create(:user, access_token: 'unique_access_token')
      @user.generate_access_token!
      expect(@user.access_token).not_to eql existing_user.access_token
    end
  end
end
