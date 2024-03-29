# frozen_string_literal: true

# require "digest/md5"
require "openssl"
# require "base64"
require "faraday"

require "beeline_iot/methods"

module BeelineIot
  class Client
    include Methods

    def initialize(auth_data = {})
      @username = auth_data[:username]
      @password = auth_data[:password]
      @client_id = auth_data[:client_id]
      @client_secret = auth_data[:client_secret]
      @grant_type = auth_data[:grant_type]
      @token_type = auth_data[:token_type]
      @expires_in = auth_data[:expires_in]
      @access_token = auth_data[:access_token]
      @refresh_token = auth_data[:refresh_token]
    end

    def login(auth_data)
      return self if @access_token

      response = request :post, "/oauth/token", auth_data
      @token_type = response["token_type"]
      @expires_in = response["expires_in"]
      @access_token = response["access_token"]
      @refresh_token = response["refresh_token"]
      self
    end

    def request(method, path, params = {})
      raise "No auth data provided" unless enough_auth_data?

      params = params.to_json
      response = client.send(method, path, params) do |request|
        add_request_headers(request, path)
      end

      result = ActiveSupport::JSON.decode(response.body)&.with_indifferent_access
      raise BeelineIot::Error, "Error [HTTP #{response.status}]: #{response.reason_phrase}" unless response.success?

      result
    rescue ActiveSupport::JSON.parse_error
      raise BeelineIot::Error, "Response is not JSON: #{response&.body}"
    end

    private

    def client
      @client ||= ::Faraday.new(url: "https://iot.beeline.ru") do |faraday|
        faraday.request :url_encoded
        faraday.response :logger if BeelineIot.log_requests
        faraday.adapter Faraday.default_adapter
      end
    end

    def add_request_headers(request, path)
      request.headers["Content-Type"] = "application/json"
      return if path == "/oauth/token"

      request.headers["X-Requested-With"] = "XMLHttpRequest" unless path == "/oauth/token"
      request.headers["Authorization"] = "#{@token_type} #{@access_token}"
    end

    def enough_auth_data?
      if [@token_type, @access_token].all? ||
         [@username, @password, @client_id, @client_secret, @grant_type].all?
        return true
      end

      false
    end

    # Class methods
    class << self
      include Methods

      def login(auth_data)
        client = BeelineIot::Client.new(auth_data)
        response = client.request :post, "/oauth/token", auth_data
        BeelineIot.username = auth_data[:username]
        BeelineIot.password = auth_data[:password]
        BeelineIot.client_id = auth_data[:client_id]
        BeelineIot.client_secret = auth_data[:client_secret]
        BeelineIot.grant_type = auth_data[:grant_type]
        BeelineIot.token_type = response["token_type"]
        BeelineIot.expires_in = response["expires_in"]
        BeelineIot.access_token = response["access_token"]
        BeelineIot.refresh_token = response["refresh_token"]
        BeelineIot
      end

      def request(method, path, params = {})
        client = BeelineIot::Client.new(
          username: BeelineIot.username,
          password: BeelineIot.password,
          client_id: BeelineIot.client_id,
          client_secret: BeelineIot.client_secret,
          grant_type: BeelineIot.grant_type,
          token_type: BeelineIot.token_type,
          expires_in: BeelineIot.expires_in,
          access_token: BeelineIot.access_token,
          refresh_token: BeelineIot.refresh_token
        )
        client.request(method, path, params)
      end
    end
  end
end
