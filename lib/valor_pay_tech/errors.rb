# frozen_string_literal: true

module ValorPayTech
  class Error < StandardError; end

  class ConfigurationError < Error; end

  class ConnectionError < Error; end

  class ApiError < Error
    attr_reader :status, :body

    def initialize(message = nil, status: nil, body: nil)
      @status = status
      @body = body
      super(message)
    end
  end

  class BadRequestError < ApiError; end

  class ServerError < ApiError; end
end
