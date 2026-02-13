# frozen_string_literal: true

module Fixtures
  def self.successful_payment_link
    {
      "error_no" => "S00",
      "url" => "https://securelink-staging.valorpaytech.com:4430/?uid=rdAEM8NyAbYmXwG3tXdH6oYr6HXAslvA&redirect=1",
      "uid" => "rdAEM8NyAbYmXwG3tXdH6oYr6HXAslvA"
    }
  end

  def self.error_response
    {
      "error_no" => "E01",
      "msg" => "Invalid parameters"
    }
  end
end
