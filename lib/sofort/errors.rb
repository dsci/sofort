module Sofort

  module Errors

    class NotAllowedCurrencyError < StandardError;end

    class NotAllowedCountryError < StandardError; end

    class NotAllowedORMAdapterError < StandardError; end

    class NoUserFoundWithTokenError < StandardError; end

    class InvalidTokenFoundError < StandardError; end
  end

end