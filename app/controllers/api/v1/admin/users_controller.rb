class Api::V1::Admin::UsersController < Api::V1::Admin::AdminController
  before_action :get_user, only: [:show, :update, :destroy]

  def index
    users = User.where.not(id: @current_user.id )
    render json: {
        users: ActiveModelSerializers::SerializableResource.new(users)
    }
  end

  def show
    render json: @user
  end

  def create
    user = User.new(user_params)
    if user.save
      render json: user,
             status: :created
    else
      render json: { errors: user.errors },
             status: :unprocessable_entity
    end
  end

  def update
    if @user.update(user_params)
      render json: @user,
             status: :ok
    else
      render json: { errors: @user.errors },
             status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy
    head 204
  end


  private
  def get_user
    @user ||= User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :phone, :address, :role, :gender, :email, :password, :password_confirmation )
  end
end
