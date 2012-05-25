module Sofort
  module Models

    module Mongoid

      def sofort

        field :sofort_credential, :type => String

        field :bank_code,         :type => String

        field :account_number,    :type => String

        field :holder,            :type => String

        define_method(:build_sofort_credential) do
          self.write_attribute(:sofort_credential,rand(36**Sofort.stretches).to_s(36))
        end  
      end

    end

  end
end
