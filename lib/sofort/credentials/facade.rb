module Sofort

  module Credentials

    class Facade < HashWithIndifferentAccess
      
      def initialize(type,resource=nil)
        @type     = type 
        @resource = resource unless resource.nil?
        #self.send("build_#{type}_digest")
      end

      def input_digest
        clear
        values = {
          :user_id => Sofort.customer_id,
          :project_id => Sofort.project_id,
          :sender_holder => "",
          :sender_account_number => @resource.account_number,
          :sender_bank_code => @resource.bank_code,
          :sender_country_id => "",
          :amount => "12",
          :currency_id => Sofort.currency,
          :reason_1 => "#{Sofort.reason} - #{@resource.email}",
          :reason_2 => "",
          :user_variable_0 => @resource.sofort_credential,
          :user_variable_1 => "",
          :user_variable_2 => "",
          :user_variable_3 => "",
          :user_variable_4 => "",
          :user_variable_5 => "",
          :project_password => Sofort.project_password 
        }   
        merge!(values)
        return Encryptors::Base.digest(self)
      end

      def response_digest
        digest 
      end

      def sofort_string
        digest = []
        self.each_value{|value|
          digest << value
        }
        digest.join("|")
      end

    end

  end
end