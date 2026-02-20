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
  amount: 149.99,
  txn_type: "sale",
  orderdescription: "Brake Pad Set",
  invoicenumber: "ORD-1042",
  email: "customer@example.com"
)

puts "Success: #{response.success?}"
puts "URL: #{response.body["url"]}"
