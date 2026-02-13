# frozen_string_literal: true

require "test_helper"

class PaymentLinksTest < ValorPayTech::TestCase
  def test_create_success
    stub_request(:post, staging_url("?hostedpagesale"))
      .to_return(status: 200, body: Fixtures.successful_payment_link.to_json)

    response = ValorPayTech.client.payment_links.create(
      amount: 25.00,
      txn_type: "sale"
    )

    assert response.success?
    assert_equal "S00", response.body["error_no"]
    refute_nil response.body["url"]
  end

  def test_create_sends_defaults
    stub_request(:post, staging_url("?hostedpagesale"))
      .with { |req|
        body = JSON.parse(req.body)
        body["epage"] == 1 && body["shipping_country"] == "US"
      }
      .to_return(status: 200, body: Fixtures.successful_payment_link.to_json)

    ValorPayTech.client.payment_links.create(amount: 1.00, txn_type: "sale")
  end

  def test_create_allows_overriding_defaults
    stub_request(:post, staging_url("?hostedpagesale"))
      .with { |req|
        body = JSON.parse(req.body)
        body["shipping_country"] == "CA"
      }
      .to_return(status: 200, body: Fixtures.successful_payment_link.to_json)

    ValorPayTech.client.payment_links.create(
      amount: 1.00,
      txn_type: "sale",
      shipping_country: "CA"
    )
  end

  def test_create_raises_when_amount_missing
    error = assert_raises(ArgumentError) do
      ValorPayTech.client.payment_links.create(txn_type: "sale")
    end
    assert_includes error.message, "amount"
  end

  def test_create_raises_when_txn_type_missing
    error = assert_raises(ArgumentError) do
      ValorPayTech.client.payment_links.create(amount: 1.00)
    end
    assert_includes error.message, "txn_type"
  end

  def test_create_passes_optional_params
    stub_request(:post, staging_url("?hostedpagesale"))
      .with { |req|
        body = JSON.parse(req.body)
        body["email"] == "test@example.com" && body["phone"] == "5551234567"
      }
      .to_return(status: 200, body: Fixtures.successful_payment_link.to_json)

    ValorPayTech.client.payment_links.create(
      amount: 1.00,
      txn_type: "sale",
      email: "test@example.com",
      phone: "5551234567"
    )
  end

  def test_create_with_api_error_response
    stub_request(:post, staging_url("?hostedpagesale"))
      .to_return(status: 200, body: Fixtures.error_response.to_json)

    response = ValorPayTech.client.payment_links.create(
      amount: 1.00,
      txn_type: "sale"
    )

    refute response.success?
    assert_equal "E01", response.body["error_no"]
  end
end
