# frozen_string_literal: true

require_relative "valor_pay_tech/version"
require_relative "valor_pay_tech/errors"
require_relative "valor_pay_tech/configuration"
require_relative "valor_pay_tech/response"
require_relative "valor_pay_tech/client"
require_relative "valor_pay_tech/resources/payment_links"

module ValorPayTech
  class << self
    def configure
      yield(configuration)
    end

    def configuration
      @configuration ||= Configuration.new
    end

    def client
      Client.new(configuration)
    end

    def reset!
      @configuration = Configuration.new
    end
  end
end
