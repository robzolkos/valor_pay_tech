# frozen_string_literal: true

module ValorPayTech
  class Response
    attr_reader :status, :body

    def initialize(status:, body:)
      @status = status
      @body = body
    end

    def success?
      status == 200 && body.is_a?(Hash) && body["error_no"] == "S00"
    end
  end
end
