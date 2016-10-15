class Api::V1::ApiController < ApplicationController

  before_action :set_global_user
  before_action :authenticate_with_token!

  # respond_to :json

  private

  def set_global_user
    @user ||= current_user if user_signed_in?
  end

end
