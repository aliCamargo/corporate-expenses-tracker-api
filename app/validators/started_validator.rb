class StartedValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.blank?

    unless record.trip.started?
      record.errors[attribute] << ( options[:message] || 'is not started' )
    end
  end
end