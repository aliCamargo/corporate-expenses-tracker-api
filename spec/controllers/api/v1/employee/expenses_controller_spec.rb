require 'rails_helper'

RSpec.describe Api::V1::Employee::ExpensesController, type: :controller do
  before(:each) do
    allow(ENV).to receive(:[]).with('TOKEN_SECRET').and_return('secret-test')
    user = FactoryGirl.create :user, role: 'employee'
    api_auth_header encode user.access_token
    @trip = FactoryGirl.create :trip, status: 'started', user_id: user.id
  end

  describe 'GET #index' do
    before(:each) do
      5.times { FactoryGirl.create :expense, trip_id: @trip.id }
      get :index, params: {trip_id: @trip.id }
    end

    it 'returns 5 records from the database' do
      expenses_response = json
      count = Expense.count
      expect( expenses_response[:expenses].count ).to eq( count )
    end

    it 'returns 5 records grouped by 1 day from the database' do
      5.times { FactoryGirl.create :expense, trip_id: @trip.id }
      get :index, params: { trip_id: @trip.id, group: true }
      expenses_response = json
      expect( expenses_response[:expenses].count ).to eql ( 1 )
    end

    it 'has a 200 status code' do
      expect(response).to have_http_status :ok
    end

  end

  describe 'GET #show' do
    before(:each) do
      @expense = FactoryGirl.create :expense, trip_id: @trip.id
      get :show, params: { trip_id: @trip.id, id: @expense.id }
    end

    it 'returns name attribute of the expense' do
      expense_response = json
      expect(expense_response[:name]).to eql  @expense.name
    end

    it 'has a 200 status code' do
      expect(response).to have_http_status :ok
    end

  end


  describe 'POST #create' do
    context 'when is successfully created' do
      before(:each) do
        @expense_attributes = FactoryGirl.attributes_for :expense
        post :create, params: { trip_id: @trip.id, expense: @expense_attributes  }
      end

      it 'renders the json representation for the trip record just created' do
        expense_response = json
        expect(expense_response[:name]).to eql @expense_attributes[:name]
      end

      it 'has a 201 status code' do
        expect(response).to have_http_status :created
      end
    end

    context "when is not created" do
      before(:each) do
        @invalid_expense_attributes = { name: nil }
        post :create, params: { trip_id: @trip.id, expense: @invalid_expense_attributes }
        @expense_response = json
      end

      it 'renders an errors json' do
        expect(@expense_response).to have_key(:errors)
      end

      it 'renders the json errors -> name' do
        expect(@expense_response[:errors][:name]).to include 'can\'t be blank'
      end

      it 'renders the json errors -> value' do
        expect(@expense_response[:errors][:value]).to include 'must be greater than 0'
      end

      it 'has a 422 status code' do
        expect(response).to have_http_status :unprocessable_entity
      end
    end
  end


  describe 'PUT #update' do
    before(:each) do
      @expense = FactoryGirl.create :expense, trip_id: @trip.id
    end

    context 'when is successfully updated' do

      before(:each) do
        @expense_attributes = { name: 'New Name' }
        put :update, params: { trip_id: @trip.id, id: @expense.id, expense: @expense_attributes }
      end

      it 'renders the json representation for the trip record just updated' do
        expense_response = json
        expect(expense_response[:name]).to eql @expense_attributes[:name]
      end

      it 'has a 200 status code' do
        expect(response).to have_http_status :ok
      end
    end

    context "when is not updated" do
      before(:each) do
        @invalid_expense_attributes = { name: nil }
        put :update, params: { trip_id: @trip.id, id: @expense.id, expense: @invalid_expense_attributes }
        @expense_response = json
      end

      it 'renders an errors json' do
        expect(@expense_response).to have_key(:errors)
      end

      it 'renders the json errors on name why the trip could not be updated' do
        expect(@expense_response[:errors][:name]).to include 'can\'t be blank'
      end

      it 'has a 422 status code' do
        expect(response).to have_http_status :unprocessable_entity
      end
    end
  end


  describe 'DELTE #Destroy' do

    it 'has a 204 status code' do
      expense = FactoryGirl.create :expense, trip_id: @trip.id
      delete :destroy, params: { trip_id: @trip.id, id: expense.id }

      expect(response).to have_http_status :no_content
    end

  end
end
