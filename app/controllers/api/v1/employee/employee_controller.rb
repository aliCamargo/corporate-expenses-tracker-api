class Api::V1::Employee::EmployeeController < Api::V1::ApiController
  before_action :authenticate_as_an_employee!
end
