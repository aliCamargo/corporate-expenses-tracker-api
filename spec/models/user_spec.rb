require 'rails_helper'

RSpec.describe User, type: :model do
  before { @user = FactoryGirl.build(:user) }
  before { @user_2 = FactoryGirl.build(:user) }

  subject { @user }

  it 'have a first_name attribute' do
    should respond_to(:first_name)
  end

  it 'have a last_name attribute' do
    should respond_to(:last_name)
  end

  it 'have a phone attribute' do
    should respond_to(:phone)
  end

  it 'have a address attribute' do
    should respond_to(:address)
  end

  it 'have a role attribute' do
    should respond_to(:role)
  end

  it 'have a gender attribute' do
    should respond_to(:gender)
  end

  it 'have a email attribute' do
    should respond_to(:email)
  end

  it 'have a password attribute' do
    should respond_to(:password)
  end


  it 'have a password_confirmation attribute' do
    should respond_to(:password_confirmation)
  end

  it 'is valid with a email and password' do
    should be_valid
  end

  it 'is invalid without email' do
    @user.email = nil
    @user.valid?
    expect( @user.errors[:email] ).to include('can\'t be blank')
  end

  it 'is invalid without password' do
    @user.password = nil
    @user.password_confirmation = nil
    @user.valid?
    expect( @user.errors[:password] ).to include('can\'t be blank')
  end

  it 'is invalid if password is not equal to password_confirmation' do
    @user.password = '123456789'
    should_not be_valid
  end
end
