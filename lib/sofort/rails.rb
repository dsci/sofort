require 'sofort/rails/routes'

module Sofort

  class Engine < Rails::Engine

    initializer "sofort.url_helpers" do
      Sofort.include_helpers(Sofort::Controllers)
    end

    initializer "sofort.orm_support" do
      require "sofort/orm/#{Sofort.orm.to_s}"
    end

  end

end