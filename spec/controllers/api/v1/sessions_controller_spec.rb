require 'rails_helper'

RSpec.describe Api::V1::SessionsController, type: :controller do

  before(:each) do
    allow(ENV).to receive(:[]).with('TOKEN_SECRET').and_return('secret-test')
    @user = FactoryGirl.create :user

    post :create, params: { session: { email: @user.email, password: '12345678' } }
  end

  describe 'POST #create' do

    context 'when the credentials are correct' do
      it 'returns the user record corresponding to the given credentials' do
        @user.reload
        json = JSON.parse(response.body)
        expect( json['token'] ).to eql TokenService.encode( { access_token: @user.access_token } )
      end

      it 'has a 200 status code' do
        expect(response).to have_http_status :ok
      end
    end

    context 'has an error when the credentials are incorrect' do

      before(:each) do
        post :create, params: { session: { email: @user.email, password: 'invalid-password' } }
      end

      it 'returns a json with an error' do
        json = JSON.parse(response.body)
        expect( json['errors']['message'] ).to eql 'Invalid email or password'
      end

      it 'has a 422 status code' do
        expect(response).to have_http_status :accepted
      end
    end
  end


  describe 'DELETE #destroy' do

    it 'has a 204 status code' do
      json = JSON.parse(response.body)
      request.headers['authorization'] = json['token']
      delete :destroy

      expect(response).to have_http_status :no_content
    end

    it 'has a 401 status code' do
      request.headers['authorization'] = 'invalid-token'
      delete :destroy

      expect(response).to have_http_status :unauthorized
    end

  end


  describe 'GET #valid_token' do

    before(:each) do
      @json = JSON.parse(response.body)
    end
    it 'has a 200 status code' do
      get :valid_token, params: { user_id: @user.id, access_token: @json['token'] }

      expect(response).to have_http_status :ok
    end

    it 'has a 202 status code when access_token is not associate to user_id' do
      get :valid_token, params: { user_id: (@user.id+2), access_token: @json['token'] }

      expect(response).to have_http_status :accepted
    end

    it 'has a 202 status code whit invalid access_token' do
      get :valid_token, params: { user_id: @user.id, access_token: 'invalid-token' }

      expect(response).to have_http_status :accepted
    end

  end

end
