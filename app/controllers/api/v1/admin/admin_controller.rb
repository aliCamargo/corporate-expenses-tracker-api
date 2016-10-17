class Api::V1::Admin::AdminController < Api::V1::ApiController
  before_action :authenticate_as_an_admin!
end
