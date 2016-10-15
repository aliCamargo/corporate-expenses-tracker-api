class Api::V1::SessionsController < Api::V1::ApiController

  skip_before_action :authenticate_with_token!, only: [:create, :valid_token, :forgot_password, :valid_forgot_password]
  skip_before_action :account_deleted!, only: [:create, :valid_token, :forgot_password, :valid_forgot_password]

  # -- Log in User
  def create
    user_password = session_params[:password]
    user_email = session_params[:email]

    user ||= User.find_by_email( user_email ) if user_email.present?

    if user && user.valid_password?( user_password )
      sign_in user, store: false
      user.generate_authentication_token!
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
    user = User.find_by( access_token: json_web_token['access_token'] )

    if user.nil? || user.deleted?
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

  # -- Send code for remember password
  def forgot_password
    user = User.find_by_email( session_params[:email] )
    if( user.present? )
      user.send_reset_password_code
      render json: {
          success: {
              code: 'send on your email'
          }
      }, status: :ok
    else
      render json: {
          errors: {
              email: 'no registered'
          }
      }, status: :accepted
    end
  end

  # -- Add code for change password
  def valid_forgot_password
    user = User.find_by_forgot_password_code( params[:session][:code] )

    if( user.present? )
      if user.update( session_params )
        sign_in user, store: false
        user.generate_authentication_token!
        user.forgot_password_code = nil
        user.save

        render json:{
            message: 'Password changed successfully',
            token:  TokenService.encode( { access_token: user.access_token } ),
            user: UserSerializer.new(user).serializable_hash
        },
               status: :ok
      else
        render json: {
            errors: user.errors
        },
        status: :accepted
      end
    else
      render json: {
          errors: {
              code: 'invalid'
          }
      }, status: :accepted
    end
  end

  private

  def session_params
    params.require(:session).permit(:email, :password, :password_confirmation)
  end

end
