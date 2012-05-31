module Sofort
  module Models

    module Mongoid

      def sofort

        field :sofort_token, :type => String

        field :bank_code,         :type => String

        field :account_number,    :type => String

        field :holder,            :type => String

        define_method(:build_sofort_token) do
          self.write_attribute(:sofort_token,rand(36**Sofort.stretches).to_s(36))
        end  

        # singleton_class is ActiveSupport specific. 
        # Pure Ruby it should be
        #
        # singleton_class = class << self do
        #                     self
        #                   end
        singleton_class.instance_eval do
          define_method(:find_by_sofort_token) do |token|
            criteria = self.send(:where, :sofort_token => token)
            return criteria.length > 0 ? criteria.first : nil
          end
        end
      end

    end

  end
end
