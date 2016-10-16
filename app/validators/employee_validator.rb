class EmployeeValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.blank?

    unless record.user.employee?
      record.errors[attribute] << ( options[:message] || "role can't be #{record.user.role}" )
    end
  end
end