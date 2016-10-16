module RequestHelpers

  module JsonHelpers
    def json
      @json ||= JSON.parse(response.body, symbolize_names: true)
    end

    def encode token
      @encode = TokenService.encode( { access_token: token } )
    end
  end

  module HeadersHelpers
    def api_auth_header token
      @request.headers['Authorization'] = token
    end
  end

end