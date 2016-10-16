require 'rails_helper'

RSpec.describe Api::V1::Admin::UsersController, type: :controller do
  before(:each) do
    allow(ENV).to receive(:[]).with('TOKEN_SECRET').and_return('secret-test')
    user = FactoryGirl.create :user, role: 'admin'
    api_auth_header encode user.access_token
  end

  describe 'GET #index' do
    before(:each) do
      5.times { FactoryGirl.create :user }
      get :index
    end

    it 'returns 5 records from the database' do
      users_response = json
      count = User.count-1
      expect(users_response[:users].count).to eq( count )
    end

    it 'has a 200 status code' do
      expect(response).to have_http_status :ok
    end

  end

  describe 'GET #show' do
    before(:each) do
      @user = FactoryGirl.create :user
      get :show, params: { id: @user.id }
    end

    it 'returns first_name attribute of the user' do
      user_response = json
      expect(user_response[:first_name]).to eql  @user.first_name
    end

    it 'has a 200 status code' do
      expect(response).to have_http_status :ok
    end

  end

  describe 'POST #create' do
    context 'when is successfully created' do

      before(:each) do
        @user_attributes = FactoryGirl.attributes_for :user
        post :create, params: { user: @user_attributes }
      end

      it 'renders the json representation for the user record just created' do
        user_response = json
        expect(user_response[:first_name]).to eql @user_attributes[:first_name]
      end

      it 'has a 201 status code' do
        expect(response).to have_http_status :created
      end
    end

    context "when is not created" do
      before(:each) do
        @invalid_user_attributes = { email: nil }
        post :create, params: { user: @invalid_user_attributes }
        @user_response = json
      end

      it 'renders an errors json' do
        expect(@user_response).to have_key(:errors)
      end

      it 'renders the json errors on email why the user could not be created' do
        expect(@user_response[:errors][:email]).to include 'can\'t be blank'
      end

      it 'renders the json errors on password why the user could not be created' do
        expect(@user_response[:errors][:password]).to include 'can\'t be blank'
      end

      it 'has a 422 status code' do
        expect(response).to have_http_status :unprocessable_entity
      end
    end
  end

  describe 'PUT #update' do
    before(:each) do
      @user = FactoryGirl.create :user
    end

    context 'when is successfully updated' do

      before(:each) do
        @user_attributes = { email: 'new@email.com' }
        put :update, params: { id: @user.id, user: @user_attributes }
      end

      it 'renders the json representation for the user record just updated' do
        user_response = json
        expect(user_response[:email]).to eql @user_attributes[:email]
      end

      it 'has a 200 status code' do
        expect(response).to have_http_status :ok
      end
    end

    context "when is not updated" do
      before(:each) do
        @invalid_user_attributes = { email: nil }
        put :update, params: { id: @user.id, user: @invalid_user_attributes }
        @user_response = json
      end

      it 'renders an errors json' do
        expect(@user_response).to have_key(:errors)
      end

      it 'renders the json errors on email why the user could not be created' do
        expect(@user_response[:errors][:email]).to include 'can\'t be blank'
      end

      it 'has a 422 status code' do
        expect(response).to have_http_status :unprocessable_entity
      end
    end
  end

end
