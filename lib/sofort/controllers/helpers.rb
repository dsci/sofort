module Sofort

  module Controllers

    module Helpers
      extend ActiveSupport::Concern

      included do
        helper_method :sofort_gateway_url
      end

      def sofort_gateway_url
        "https:://www.sofort-ueberweisung.#{Sofort.country.to_s}/payment/start"
      end

    end



  end

end