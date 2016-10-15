class Api::V1::ApiController < ApplicationController

  before_action :set_global_user
  before_action :authenticate_with_token!
  before_action :account_deleted!

  respond_to :json

  private

  def set_global_user
    @user ||= current_user if user_signed_in?
  end


  def render_404
    render json: { error: 'not-found' }.to_json, status: 404
  end

  def render_500
    render json: { error: 'internal-server-error' }.to_json, status: 500
  end

end
