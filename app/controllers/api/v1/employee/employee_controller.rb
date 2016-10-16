class Api::V1::Employee::EmployeeController < ApplicationController
  before_action :authenticate_as_an_employee!
end
