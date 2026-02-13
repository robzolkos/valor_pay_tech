#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative "../lib/valor_pay_tech"

ValorPayTech.configure do |c|
  c.app_id      = ENV.fetch("VALOR_APP_ID")
  c.app_key     = ENV.fetch("VALOR_APP_KEY")
  c.epi         = ENV.fetch("VALOR_EPI")
  c.environment = :staging
end

response = ValorPayTech.client.payment_links.create(
  amount: 500.00,
  txn_type: "sale",
  orderdescription: "Surgical Invoice",
  invoicenumber: "4DF42",
  email: "test@example.com"
)

puts "Success: #{response.success?}"
puts "URL: #{response.body["url"]}"
