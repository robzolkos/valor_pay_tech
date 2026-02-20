# ValorPayTech

Ruby client for the [Valor PayTech](https://valorpaytech.com/) Hosted Payment Page API. Creates payment links that redirect customers to a Valor-hosted checkout page.

## Installation

Add to your Gemfile and run `bundle install`:

```ruby
gem "valor_pay_tech"
```

## Configuration

```ruby
ValorPayTech.configure do |c|
  c.app_id      = ENV.fetch("VALOR_APP_ID")
  c.app_key     = ENV.fetch("VALOR_APP_KEY")
  c.epi         = ENV.fetch("VALOR_EPI")
  c.environment = :staging  # or :production
end
```

Credentials are available in the Valor Portal under **Virtual Terminal > Manage > API Keys**.

## Usage

### Creating a payment link

```ruby
response = ValorPayTech.client.payment_links.create(
  amount: 149.99,
  txn_type: "sale",
  orderdescription: "Brake Pad Set",
  invoicenumber: "ORD-1042",
  email: "customer@example.com"
)

response.success?       # => true
response.body["url"]    # => "https://securelink-staging.valorpaytech.com:443//?uid=...&redirect=1"
response.body["uid"]    # => "8eEApWlQXRDQOvbkN2U9rqBEz9ND7uk0"
```

### With redirect URLs

```ruby
response = ValorPayTech.client.payment_links.create(
  amount: 149.99,
  txn_type: "sale",
  orderdescription: "Brake Pad Set",
  invoicenumber: "ORD-1042",
  email: "customer@example.com",
  success_url: "https://yourapp.com/payments/success",
  failure_url: "https://yourapp.com/payments/failure"
)
```

### Available parameters

| Parameter | Required | Description |
|-----------|----------|-------------|
| `amount` | Yes | Transaction amount (up to $99,999.99) |
| `txn_type` | Yes | `"sale"` or `"auth"` |
| `orderdescription` | No | Text shown on payment page (up to 50 chars) |
| `invoicenumber` | No | Invoice number (displayed separately on payment page) |
| `customer_name` | No | Customer name |
| `email` | No | Customer email |
| `phone` | No | Customer phone (10 digits) |
| `tax` | No | Tax amount |
| `surcharge` | No | Additional fee amount |
| `success_url` | No | Redirect URL after successful payment |
| `failure_url` | No | Redirect URL after failed payment |
| `redirect_url` | No | General callback URL |
| `never_expire` | No | `"1"` to prevent link expiration |
| `active_on` | No | Date when link becomes active |
| `lineItems` | No | Array of line item details (L2/L3) |

Defaults applied automatically: `epage: 1`, `shipping_country: "US"`.

### Error handling

```ruby
begin
  response = ValorPayTech.client.payment_links.create(
    amount: 500.00,
    txn_type: "sale"
  )
rescue ValorPayTech::ConfigurationError => e
  # Missing or invalid credentials
rescue ValorPayTech::BadRequestError => e
  e.status  # => 400
  e.body    # => parsed JSON
rescue ValorPayTech::ServerError => e
  # 5xx from Valor
rescue ValorPayTech::ConnectionError => e
  # Network failure
end
```

Note: A `200` response from Valor doesn't always mean success. Check `response.success?` which verifies both the HTTP status and `error_no == "S00"`.

## E2E testing against staging

The `script/create_payment_link.rb` script creates a real payment link on the Valor staging environment:

```bash
VALOR_APP_ID=xxx VALOR_APP_KEY=xxx VALOR_EPI=xxx ruby script/create_payment_link.rb
```

Open the returned URL in a browser to see the hosted payment page.

## Releasing

Releases are automated via two GitHub Actions workflows:

- **`release-please.yml`** — watches commits on master, opens a release PR that bumps the version and changelog. Merging the PR creates a GitHub release.
- **`release.yml`** — triggered by the GitHub release, runs tests and publishes the gem to RubyGems.

Use [conventional commits](https://www.conventionalcommits.org/) to drive version bumps: `fix:` for patch, `feat:` for minor, `feat!:` for major.

## Running tests

```bash
bundle install
bundle exec rake test
```

Tests use WebMock to stub all HTTP requests — no credentials or network access required.

## API reference

- [Hosted Payment Page API](https://valorapi.readme.io/reference/epage)
- [API Keys Guide](https://valorapi.readme.io/reference/merchant-management-using-api-keys)
- [Error Codes](https://valorapi.readme.io/reference/error-code-description)
