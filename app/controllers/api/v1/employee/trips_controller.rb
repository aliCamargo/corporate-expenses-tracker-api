class Api::V1::Employee::TripsController < Api::V1::Employee::EmployeeController
  before_action :get_trip, only: [:show]

  def index
    trips = @current_user.trips
    render json: {
        trips: ActiveModelSerializers::SerializableResource.new(trips)
    }
  end

  def show
    render json: @trip
  end

  private
  def get_trip
    @trip ||= @current_user.trips.find(params[:id])
  end
end
