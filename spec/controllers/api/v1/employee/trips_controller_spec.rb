require 'rails_helper'

RSpec.describe Api::V1::Employee::TripsController, type: :controller do
  before(:each) do
    allow(ENV).to receive(:[]).with('TOKEN_SECRET').and_return('secret-test')
    @user = FactoryGirl.create :user, role: 'employee'
    api_auth_header encode @user.access_token
  end

  describe 'GET #index' do
    before(:each) do
      5.times { FactoryGirl.create :trip, user_id: @user.id, status: 'finished' }
      get :index
    end

    it 'returns 5 records finished from the database' do
      trips_response = json
      count = @user.trips.count
      expect( trips_response[:trips].count ).to eq( count )
    end

    it 'has a 200 status code' do
      expect(response).to have_http_status :ok
    end

  end

  describe 'GET #show' do
    before(:each) do
      @trip = FactoryGirl.create :trip, user_id: @user.id
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

end
