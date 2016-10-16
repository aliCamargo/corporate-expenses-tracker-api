require 'rails_helper'

RSpec.describe Api::V1::Admin::TripsController, type: :controller do
  before(:each) do
    allow(ENV).to receive(:[]).with('TOKEN_SECRET').and_return('secret-test')
    user = FactoryGirl.create :user, role: 'admin'
    api_auth_header encode user.access_token
  end

  describe 'GET #index' do
    before(:each) do
      5.times { FactoryGirl.create :trip }
      get :index
    end

    it 'returns 5 records from the database' do
      trips_response = json
      count = Trip.count
      expect( trips_response[:trips].count ).to eq( count )
    end

    it 'has a 200 status code' do
      expect(response).to have_http_status :ok
    end

  end

  describe 'GET #show' do
    before(:each) do
      @trip = FactoryGirl.create :trip
      get :show, params: { id: @trip.id }
    end

    it 'returns name attribute of the trip' do
      trip_response = json
      expect(trip_response[:name]).to eql  @trip.name
    end

    it 'has a 200 status code' do
      expect(response).to have_http_status :ok
    end

  end


  describe 'POST #create' do
    context 'when is successfully created' do
      before(:each) do
        @trip_attributes = FactoryGirl.attributes_for :trip
        post :create, params: { trip: @trip_attributes }
      end

      it 'renders the json representation for the trip record just created' do
        trip_response = json
        expect(trip_response[:name]).to eql @trip_attributes[:name]
      end

      it 'has a 201 status code' do
        expect(response).to have_http_status :created
      end
    end

    context "when is not created" do
      before(:each) do
        @invalid_trip_attributes = { name: nil }
        post :create, params: { trip: @invalid_trip_attributes }
        @trip_response = json
      end

      it 'renders an errors json' do
        expect(@trip_response).to have_key(:errors)
      end

      it 'renders the json errors on name why the trip could not be created' do
        expect(@trip_response[:errors][:name]).to include 'can\'t be blank'
      end

      it 'renders the json errors on user why the trip could not be created' do
        expect(@trip_response[:errors][:user_id]).to include 'can\'t be blank'
      end

      it 'renders the json errors on budget why the trip could not be created' do
        expect(@trip_response[:errors][:budget]).to include 'must be greater than 0'
      end

      it 'has a 422 status code' do
        expect(response).to have_http_status :unprocessable_entity
      end
    end
  end


  describe 'PUT #update' do
    before(:each) do
      @trip = FactoryGirl.create :trip
    end

    context 'when is successfully updated' do

      before(:each) do
        @trip_attributes = { name: 'New Name' }
        put :update, params: { id: @trip.id, trip: @trip_attributes }
      end

      it 'renders the json representation for the trip record just updated' do
        trip_response = json
        expect(trip_response[:name]).to eql @trip_attributes[:name]
      end

      it 'has a 200 status code' do
        expect(response).to have_http_status :ok
      end
    end

    context "when is not updated" do
      before(:each) do
        @invalid_trip_attributes = { name: nil }
        put :update, params: { id: @trip.id, trip: @invalid_trip_attributes }
        @trip_response = json
      end

      it 'renders an errors json' do
        expect(@trip_response).to have_key(:errors)
      end

      it 'renders the json errors on name why the trip could not be updated' do
        expect(@trip_response[:errors][:name]).to include 'can\'t be blank'
      end

      it 'has a 422 status code' do
        expect(response).to have_http_status :unprocessable_entity
      end
    end
  end


  describe 'DELTE #Destroy' do

    it 'has a 204 status code' do
      trip = FactoryGirl.create :trip
      delete :destroy, params: { id: trip.id }

      expect(response).to have_http_status :no_content
    end

  end

end
