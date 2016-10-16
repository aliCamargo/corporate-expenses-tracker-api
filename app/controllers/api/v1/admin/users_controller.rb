class Api::V1::Admin::UsersController < Api::V1::Admin::AdminController
  before_action :get_user, only: [:show, :update, :destroy]

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

  private
  def get_user
    @user ||= User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :phone, :address, :role, :gender, :email, :password, :password_confirmation )
  end
end