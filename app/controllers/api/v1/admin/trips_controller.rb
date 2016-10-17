class Api::V1::Admin::TripsController < Api::V1::Admin::AdminController
  # before_action :get_user, if: Proc.new{ params[:user_id].present? }
  before_action :get_trip, only: [:show, :update, :destroy]

  def index
    trips = Trip.all
    render json: {
        trips: ActiveModelSerializers::SerializableResource.new(trips)
    }
  end

  def show
    render json: @trip
  end

  def create
    trip = Trip.new(trip_params)
    if trip.save
      render json: trip,
             status: :created
    else
      render json: { errors: trip.errors },
             status: :unprocessable_entity
    end
  end

  def update
    if @trip.update(trip_params)
      render json: @trip,
             status: :ok
    else
      render json: { errors: @trip.errors },
             status: :unprocessable_entity
    end
  end

  def destroy
    @trip.destroy
    head 204
  end


  private
  def get_user
    @user ||= User.find(params[:user_id])
  end

  def get_trip
    @trip ||= Trip.find(params[:id])
  end

  def trip_params
    params.require(:trip).permit( :name, :description, :budget, :status, :user_id )
  end
end
