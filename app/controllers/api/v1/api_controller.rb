class Api::V1::ApiController < ApplicationController

  before_action :authenticate_with_token!
  before_action :set_global_current_user

  # respond_to :json

  private

  def set_global_current_user
    @current_user ||= current_user if user_signed_in?
  end

end
