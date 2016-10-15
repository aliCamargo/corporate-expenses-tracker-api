class TokenService < Service

  class << self
    require 'jwt'

    def encode( hash )
      JWT.encode( hash, ENV['TOKEN_SECRET'])
    end

    def decode( token )
      begin
        JWT.decode( token, ENV['TOKEN_SECRET'] ).first
      rescue JWT::DecodeError
        nil
      end
    end

  end

end

