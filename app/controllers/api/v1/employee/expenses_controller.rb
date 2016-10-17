class Api::V1::Employee::ExpensesController < Api::V1::Employee::EmployeeController
  before_action :get_trip
  before_action :get_expense, only: [:show, :update, :destroy]

  def index
    expenses = @trip.expenses
    render json: {
        expenses: ActiveModelSerializers::SerializableResource.new(expenses)
    }
  end

  def show
    render json: @expense
  end

  def create
    expense = @trip.expenses.new( expense_params )
    if expense.save
      render json: expense,
             status: :created
    else
      render json: { errors: expense.errors },
             status: :unprocessable_entity
    end
  end

  def update
    if @expense.update(expense_params)
      render json: @expense,
             status: :ok
    else
      render json: { errors: @expense.errors },
             status: :unprocessable_entity
    end
  end

  def destroy
    @expense.destroy
    head 204
  end


  private
  def get_trip
    @trip ||= @current_user.trips.find( params[:trip_id] )
  end

  def get_expense
    @expense ||= @trip.expenses.find( params[:id] )
  end

  def expense_params
    params.require(:expense).permit( :name, :note, :value, :trip_id )
  end

end
