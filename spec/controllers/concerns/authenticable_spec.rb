require 'spec_helper'
require 'rails_helper'

class Authentication
  include Authenticable
end

RSpec.describe Authenticable, type: :controller do
  let(:authentication) { Authentication.new }
  subject { authentication }

  before( :each ) do
    allow(ENV).to receive(:[]).with('TOKEN_SECRET').and_return('secret-test')
  end

  describe '#current_user' do
    it 'should return the user from the authorization header' do
      @user = FactoryGirl.create :user
      allow(authentication).to receive(:current_user).and_return(@user)

      expect(authentication.current_user.access_token).to eql @user.access_token
    end
  end

  describe '#user_signed_in?' do
    context 'when there is a user on \'session\'' do
      before do
        @user = FactoryGirl.create :user
        allow(authentication).to receive(:current_user).and_return(@user)
      end

      it {should be_user_signed_in}
    end

    context 'when there is no user on \'session\'' do
      before do
        @user = FactoryGirl.create :user
        allow(authentication).to receive(:current_user).and_return(nil)
      end

      it {should_not be_user_signed_in}
    end
  end

  describe '#authenticate_with_token!' do
    before do
      @user = FactoryGirl.create :user
      allow(authentication).to receive(:current_user).and_return(nil)
      allow(response).to receive(:status).and_return(401)
      allow(response).to receive(:body).and_return( { errors: { token: 'Not authenticated' } }.to_json )
    end

    it 'should render a json error message' do
      expect(json[:errors][:token]).to eql 'Not authenticated'
    end

    it 'has a 401 status code' do
      expect(response).to have_http_status :unauthorized
    end
  end

end