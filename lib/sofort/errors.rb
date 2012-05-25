module Sofort

  module Errors

    class NotAllowedCurrencyError < StandardError;end

    class NotAllowedCountryError < StandardError; end

    class NotAllowedORMAdapterError < StandardError; end
  end

end