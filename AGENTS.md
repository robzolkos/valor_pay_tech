# valor_pay_tech

Ruby gem providing a client for the Valor PayTech Hosted Payment Page API.

## Project structure

- `lib/valor_pay_tech/client.rb` — HTTP client, injects auth credentials into every request
- `lib/valor_pay_tech/configuration.rb` — holds `app_id`, `app_key`, `epi`, `environment`
- `lib/valor_pay_tech/resources/payment_links.rb` — `PaymentLinks#create` wraps the `?hostedpagesale` endpoint
- `lib/valor_pay_tech/response.rb` — wraps HTTP response; `success?` checks HTTP 200 and `error_no == "S00"`
- `lib/valor_pay_tech/errors.rb` — error hierarchy: `ConfigurationError`, `ConnectionError`, `ApiError`, `BadRequestError`, `ServerError`
- `script/create_payment_link.rb` — E2E script for manual testing against staging

## Running tests

```bash
bundle install
bundle exec rake test
```

Tests use WebMock — no credentials or network access required.

## E2E testing against staging

```bash
VALOR_APP_ID=xxx VALOR_APP_KEY=xxx VALOR_EPI=xxx ruby script/create_payment_link.rb
```

## Credentials

Three credentials are required: `app_id`, `app_key`, and `epi` (a 10-digit virtual terminal identifier starting with 2). Obtain production credentials from Valor PayTech support.

## Releasing

Releases are managed by [release-please](https://github.com/googleapis/release-please). Use conventional commits and it handles the rest:

- `fix: ...` — patch release (0.1.0 → 0.1.1)
- `feat: ...` — minor release (0.1.0 → 0.2.0)
- `feat!: ...` or `fix!: ...` — major release (0.1.0 → 1.0.0)

When there are releasable commits on master, release-please opens a PR that bumps `lib/valor_pay_tech/version.rb` and updates the changelog. Merging that PR creates a GitHub release, which triggers the release workflow (`release.yml`) to publish the gem to RubyGems.

Two workflows are involved:

- `.github/workflows/release-please.yml` — watches commits on master, maintains the release PR, bumps `version.rb`, and creates the GitHub release
- `.github/workflows/release.yml` — triggered by the GitHub release being published, runs tests and publishes the gem to RubyGems
