module Authenticable
  extend ActiveSupport::Concern

  # Devise methods overwrites
  def current_user
    token = request.headers['Authorization']
    json_web_token = TokenService.decode( token )
    access_token = json_web_token.nil? ? nil : json_web_token['access_token']
    @current_user ||= User.find_by_access_token( access_token )
  end

  def user_signed_in?
    current_user.present?
  end

  def authenticate_with_token!
    render json: { errors: { token: 'Not authenticated' } },
           status: :unauthorized unless user_signed_in?
  end

  def user_admin?
    current_user.admin?
  end

  def authenticate_as_an_admin!
    render json: { errors: { role: 'Unauthorized' } },
           status: :unauthorized unless user_admin?
  end

end