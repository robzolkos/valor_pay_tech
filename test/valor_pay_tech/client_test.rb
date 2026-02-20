# frozen_string_literal: true

require "test_helper"

class ClientTest < ValorPayTech::TestCase
  def test_raises_when_configuration_invalid
    ValorPayTech.reset!
    assert_raises(ValorPayTech::ConfigurationError) { ValorPayTech.client }
  end

  def test_post_injects_auth_credentials
    stub_request(:post, staging_url("?hostedpagesale"))
      .with { |req|
        body = JSON.parse(req.body)
        body["appid"] == "test_app_id" &&
          body["appkey"] == "test_app_key" &&
          body["epi"] == "2000000001"
      }
      .to_return(status: 200, body: Fixtures.successful_payment_link.to_json)

    client = ValorPayTech.client
    response = client.post("?hostedpagesale", amount: 1.00)

    assert response.success?
  end

  def test_post_raises_bad_request_error_on_400
    stub_request(:post, staging_url("?hostedpagesale"))
      .to_return(status: 400, body: { error: "bad request" }.to_json)

    client = ValorPayTech.client
    assert_raises(ValorPayTech::BadRequestError) { client.post("?hostedpagesale", {}) }
  end

  def test_post_raises_server_error_on_500
    stub_request(:post, staging_url("?hostedpagesale"))
      .to_return(status: 500, body: { error: "internal" }.to_json)

    client = ValorPayTech.client
    assert_raises(ValorPayTech::ServerError) { client.post("?hostedpagesale", {}) }
  end

  def test_post_raises_connection_error_on_network_failure
    stub_request(:post, staging_url("?hostedpagesale"))
      .to_raise(Errno::ECONNREFUSED)

    client = ValorPayTech.client
    assert_raises(ValorPayTech::ConnectionError) { client.post("?hostedpagesale", {}) }
  end

  def test_post_handles_non_json_response
    stub_request(:post, staging_url("?hostedpagesale"))
      .to_return(status: 200, body: "not json")

    client = ValorPayTech.client
    response = client.post("?hostedpagesale", {})

    assert_equal({ "raw" => "not json" }, response.body)
  end

  def test_payment_links_accessor
    client = ValorPayTech.client
    assert_instance_of ValorPayTech::Resources::PaymentLinks, client.payment_links
    assert_same client.payment_links, client.payment_links
  end
end
