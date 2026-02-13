# frozen_string_literal: true

module ValorPayTech
  module Resources
    class PaymentLinks
      REQUIRED_PARAMS = %i[amount txn_type].freeze

      DEFAULTS = {
        epage: 1,
        shipping_country: "US"
      }.freeze

      def initialize(client)
        @client = client
      end

      def create(params = {})
        validate!(params)
        @client.post("?hostedpagesale", DEFAULTS.merge(params))
      end

      private

      def validate!(params)
        missing = REQUIRED_PARAMS.select { |key| params[key].nil? }
        return if missing.empty?

        raise ArgumentError, "Missing required parameters: #{missing.join(", ")}"
      end
    end
  end
end
