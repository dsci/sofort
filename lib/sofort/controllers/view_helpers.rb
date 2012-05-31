module Sofort

  module Controllers

    module ViewHelpers
      extend ActiveSupport::Concern

      included do
      end

      def sofort_form(resource, opt={})
        options       =   opt.to_options
        amount        =   options.fetch(:amount, 0) 
        values_fields =   hidden_field_tag("user_id", Sofort.customer_id)
        values_fields +=  hidden_field_tag("project_id", Sofort.project_id)
        values_fields +=  hidden_field_tag("hash", Sofort::Credentials::Facade.new(resource).input_digest)
        values_fields +=  hidden_field_tag("amount", amount)
        values_fields +=  hidden_field_tag("user_variable_0", resource.sofort_token)
        values_fields +=  hidden_field_tag("reason_1", Sofort.reason(resource))
        Sofort.not_modifiable_params.each do |param|
          begin
            values_fields += hidden_field_tag(Sofort::PARAM_MAPPINGS[param], resource.send(param))
          rescue => e
            p e.message
          end
        end

        return values_fields
      end
      alias_method :sofort_fields, :sofort_form

    end

  end

end