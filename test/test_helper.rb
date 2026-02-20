# frozen_string_literal: true

require "minitest/autorun"
require "webmock/minitest"
require "valor_pay_tech"
require_relative "support/fixtures"

WebMock.disable_net_connect!

module ValorPayTech
  class TestCase < Minitest::Test
    def setup
      ValorPayTech.reset!
      ValorPayTech.configure do |c|
        c.app_id  = "test_app_id"
        c.app_key = "test_app_key"
        c.epi     = "2000000001"
      end
    end

    def staging_url(path = "")
      "https://securelink-staging.valorpaytech.com:4430/#{path}"
    end
  end
end
