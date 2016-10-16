class SingleStartedValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.blank?
    started_trip = record.user ? record.user.trips.started.count : 0

    if started_trip >= 1
      record.errors[attribute] << ( options[:message] || 'has already a started trip' )
    end
  end
end