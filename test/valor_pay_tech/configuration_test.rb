# frozen_string_literal: true

require "test_helper"

class ConfigurationTest < Minitest::Test
  def setup
    @config = ValorPayTech::Configuration.new
  end

  def test_defaults_to_staging
    assert_equal :staging, @config.environment
  end

  def test_staging_base_url
    assert_equal "https://securelink-staging.valorpaytech.com:4430", @config.base_url
  end

  def test_production_base_url
    @config.environment = :production
    assert_equal "https://securelink.valorpaytech.com", @config.base_url
  end

  def test_unknown_environment_raises
    @config.environment = :unknown
    assert_raises(ValorPayTech::ConfigurationError) { @config.base_url }
  end

  def test_validate_raises_when_app_id_missing
    @config.app_key = "key"
    @config.epi = "epi"

    error = assert_raises(ValorPayTech::ConfigurationError) { @config.validate! }
    assert_includes error.message, "app_id"
  end

  def test_validate_raises_when_multiple_missing
    error = assert_raises(ValorPayTech::ConfigurationError) { @config.validate! }
    assert_includes error.message, "app_id"
    assert_includes error.message, "app_key"
    assert_includes error.message, "epi"
  end

  def test_validate_passes_with_all_credentials
    @config.app_id = "id"
    @config.app_key = "key"
    @config.epi = "epi"

    assert_nil @config.validate!
  end

  def test_validate_raises_for_blank_values
    @config.app_id = "  "
    @config.app_key = "key"
    @config.epi = "epi"

    error = assert_raises(ValorPayTech::ConfigurationError) { @config.validate! }
    assert_includes error.message, "app_id"
  end
end
