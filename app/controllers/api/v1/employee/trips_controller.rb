class Api::V1::Employee::TripsController < Api::V1::Employee::EmployeeController
  before_action :get_trip, only: [:show, :update]

  def index
    trips = @current_user.trips
    render json: {
        trips: ActiveModelSerializers::SerializableResource.new(trips)
    }
  end

  def show
    render json: @trip
  end

  def update
    if @trip.update( trip_params )
      render json: @trip,
             status: :ok
    else
      render json: { errors: @trip.errors },
             status: :unprocessable_entity
    end
  end

  private
  def get_trip
    @trip ||= @current_user.trips.find(params[:id])
  end

  def trip_params
    params.require(:trip).permit(:status)
  end
end
