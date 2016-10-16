class Api::V1::Admin::AdminController < ApplicationController
  before_action :authenticate_as_an_admin!
end
