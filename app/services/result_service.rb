
class ResultService

  def initialize( success = false, parameters = {} )
    @success = success
    @parameters = parameters
  end

  def set_status( success )
    @success = success
  end

  def set_parameters( parameters )
    @parameters = parameters
  end

  def success?
    @success
  end

  def error?
    !@success
  end

  def parameters
    @parameters
  end

  def method_missing(name, *args, &blk)
    if args.empty? && blk.nil? && @parameters.has_key?(name)
      @parameters[name]
    else
      super
    end
  end

end