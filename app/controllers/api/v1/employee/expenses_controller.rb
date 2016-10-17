class Api::V1::Employee::ExpensesController < Api::V1::Employee::EmployeeController
  before_action :get_trip
  before_action :get_expense, only: [:show, :update, :destroy]

  def index
    expenses = @trip.expenses
    if( params[:group].present? )
      expenses = group_expenses( expenses )
    else
      expenses = ActiveModelSerializers::SerializableResource.new( expenses )
    end

    render json: {
        expenses: expenses
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
    params.require(:expense).permit( :name, :note, :value, :trip_id, :all_tags )
  end

  def group_expenses( objects )
    objects = objects.sort_by(&:created_at).reverse
    result = {}

    unless objects.blank?
      objects.each do |obj|

        serializer_data = ExpenseSerializer.new(obj).serializable_hash

        key =
            if (obj.created_at <= Date.today.end_of_day && obj.created_at >= Date.today.beginning_of_day)
              'today'
            elsif (obj.created_at <= Date.yesterday.end_of_day && obj.created_at >= Date.yesterday.beginning_of_day)
              'yesterday'
            elsif (obj.created_at <= Date.tomorrow.end_of_day && obj.created_at >= Date.tomorrow.beginning_of_day)
              'tomorrow'
            else
              I18n.l(obj.created_at, format: "%B %d")
            end

        result[key] = [] if result[key].blank?
        result[key] << serializer_data

      end
    end

    result

  end

end
