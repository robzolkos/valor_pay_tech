# frozen_string_literal: true

require "net/http"
require "json"
require "uri"

module ValorPayTech
  class Client
    attr_reader :configuration

    def initialize(configuration)
      @configuration = configuration
      configuration.validate!
    end

    def payment_links
      @payment_links ||= Resources::PaymentLinks.new(self)
    end

    def post(path, params = {})
      uri = URI("#{configuration.base_url}/#{path}")
      request = Net::HTTP::Post.new(uri)
      request["Content-Type"] = "application/json"
      request.body = build_body(params).to_json

      response = execute(uri, request)
      handle_response(response)
    rescue Errno::ECONNREFUSED, Errno::ETIMEDOUT, SocketError, Net::OpenTimeout, Net::ReadTimeout => e
      raise ConnectionError, "Connection failed: #{e.message}"
    end

    private

    def build_body(params)
      {
        appid: configuration.app_id,
        appkey: configuration.app_key,
        epi: configuration.epi
      }.merge(params)
    end

    def execute(uri, request)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = uri.scheme == "https"
      http.open_timeout = 10
      http.read_timeout = 30
      http.request(request)
    end

    def handle_response(http_response)
      status = http_response.code.to_i
      body = parse_body(http_response.body)

      case status
      when 200..299
        Response.new(status: status, body: body)
      when 400..499
        raise BadRequestError.new("Bad request: #{http_response.body}", status: status, body: body)
      when 500..599
        raise ServerError.new("Server error: #{http_response.body}", status: status, body: body)
      else
        raise ApiError.new("Unexpected response: #{status}", status: status, body: body)
      end
    end

    def parse_body(raw)
      JSON.parse(raw)
    rescue JSON::ParserError
      { "raw" => raw }
    end
  end
end
