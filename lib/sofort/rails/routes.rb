module ActionDispatch::Routing

  class Mapper

    def sofort_callback(*args)
      options     = args.extract_options!
      controller  = options.fetch(:controller, 'sofort/callback')
      action      = options.fetch(:action, 'cb')
      as          = options.fetch(:as, '/payment/sofort/cb')

      match as, :to => "#{controller}##{action}"
    end

    def sofort_notification(*options)
    end

  end

end