# frozen_string_literal: true

module ValorPayTech
  class Configuration
    ENVIRONMENTS = {
      staging: "https://securelink-staging.valorpaytech.com:4430",
      production: "https://securelink.valorpaytech.com"
    }.freeze

    attr_accessor :app_id, :app_key, :epi, :environment

    def initialize
      @environment = :staging
    end

    def base_url
      ENVIRONMENTS.fetch(environment) do
        raise ConfigurationError, "Unknown environment: #{environment}. Use :staging or :production."
      end
    end

    def validate!
      missing = []
      missing << "app_id" if app_id.nil? || app_id.to_s.strip.empty?
      missing << "app_key" if app_key.nil? || app_key.to_s.strip.empty?
      missing << "epi" if epi.nil? || epi.to_s.strip.empty?

      return if missing.empty?

      raise ConfigurationError, "Missing required configuration: #{missing.join(", ")}"
    end
  end
end
