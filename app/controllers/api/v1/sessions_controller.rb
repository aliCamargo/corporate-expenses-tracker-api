class Api::V1::SessionsController < Api::V1::ApiController

  skip_before_action :authenticate_with_token!, only: [:create, :valid_token, :forgot_password, :valid_forgot_password]

  # -- Log in User
  def create
    user_password = session_params[:password]
    user_email = session_params[:email]

    user ||= User.find_by_email( user_email ) if user_email.present?

    if user && user.valid_password?( user_password )
      sign_in user, store: false
      user.generate_access_token!
      user.save

      render json:{
          token:  TokenService.encode( { access_token: user.access_token } ),
          user: UserSerializer.new(user).serializable_hash
        },
        status: :ok
    else
      render json: {
              errors: {
                  message: 'Invalid email or password'
              }
            },
            status: :accepted
    end
  end

  # -- Log out User
  def destroy
    @user.update_attribute(:access_token, nil)
    head 204
  end

  # -- validation access_token
  def valid_token
    json_web_token = TokenService.decode( params[:access_token] )
    user = json_web_token.present? ? User.find_by( access_token: json_web_token['access_token'] ) : nil

    if user.nil?
      render json: {
          errors: {
              access_token: 'is invalid'
          }
      }, status: :accepted
    else
      if user.id.to_s == params[:user_id]
        render json: {
            success: {
                access_token: 'is valid'
            }
        }, status: :ok
      else
        render json: {
            errors: {
                auth_token: "is invalid for user with id #{params[:user_id]}"
            }
        },
        status: :accepted
      end
    end
  end

  # -- Get a current user
  def me
    if @user
      render json: @user,
             status: :ok
    end
  end

  private

  def session_params
    params.require(:session).permit(:email, :password, :password_confirmation)
  end

end
