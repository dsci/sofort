require 'bundler/setup'

begin 
  Bundler.setup
rescue Bundler::GemNotFound
  raise RuntimeError, "Bundler couldn't find some gems." + 
    "Did you run 'bundle install'?"
end

%w(rails orm_adapter).each { |library| require library }

module Sofort

  extend self

  autoload :Errors,           'sofort/errors'

  module Credentials
    autoload :Facade,         'sofort/credentials/facade'
  end

  module Encryptors
    autoload :Base,  'sofort/crypt/base'
  end

  module Controllers
    autoload :Helpers,        'sofort/controllers/helpers'
    autoload :ViewHelpers,    'sofort/controllers/view_helpers'
  end

  ALLOWED_CURRENCIES    = [:eur,:chf,:pln, :gbp]
  ALLOWED_COUNTRIES     = [:de,:ch, :at]
  ALLOWED_ORM_ADAPTERS  = [:mongoid, :active_record]

  # Some mappings which are needed to convert user attributes to
  # sofortueberweisung.de params.
  PARAM_MAPPINGS        = {
    :account_number   => "sender_account_number",
    :bank_code        => "sender_bank_code",
    :holder           => "sender_holder",
    :country_id       => "sender_country_id",
    :user_country_id  => "sender_country_id"
  }

  #############################################################################
  # Required configuration fields                                             #
  #############################################################################

  # User or customer id at sofortueberweisung.de
  mattr_accessor  :customer_id

  # The project id for which the payment should be done. 
  # Any id registered at sofortueberweisung.de
  mattr_accessor  :project_id

  # The project credentials, like sofortueberweisung say
  # 'Projekt-Passwort'. 
  # This is required by 'sofort' and not optional. 
  mattr_accessor  :project_credentials

  # The response credentials, like sofortueberweisung say
  # 'Benachrichtigungspassword'.
  # This is required by 'sofort' and not optional.
  mattr_accessor  :response_credentials

  # The orm adapter which is used. 
  # Currently supported are Mongoid.
  def orm=(orm)
    unless ALLOWED_ORM_ADAPTERS.include?(orm)
      raise Errors::NotAllowedORMAdapterError.new, "#{orm.to_s} adapter is currently not supported."
    end
    #require "sofort/orm/#{orm.to_s}"
    @@orm = orm
  end

  def orm
    @@orm ||= :mongoid
  end

  #############################################################################
  # Optional configuration fields                                             #
  #############################################################################

  # Parameters which are not modifiable by user. 
  # They are configured at sofortueberweisung.de
  #
  # Possible entries are:
  # :account_number,:bank_code, :holder, :user_country_id,:country_id
  mattr_writer :not_modifiable_params

  # A database attribute field at the User model. 
  # Note that 'sofort' requires a current_user method
  # which returns an instance of the actual logged in
  # user.
  # This is an optional field and only used if 
  # prepaid_mode is true
  mattr_accessor  :user_balance
  
  # A custom encryptor which have to available through
  # 'digest/sha2'
  # Currently supported are sha256 and sha512, whereby 
  # sha512 is the default one. 
  mattr_writer    :encryptor

  # 
  mattr_writer    :timeout

  # A number which length the sofort_token attribute 
  # should have. Default to 128.
  mattr_writer    :stretches

  # A flag if a prepaid_mode or 'coin' mode should be used.
  # If it is true, 'sofort' updates the users balance. 
  # 
  mattr_writer    :prepaid_mode
  @@prepaid_mode = false

  # A 'Verwendungszweck' which is used as a suffix before users
  # email to identify the payment. 
  # Defaults to an empty string.
  mattr_writer    :reason
  @@reason = "1"

  # A anonymous function which is called after transaction was
  # successful. 
  # This has to be a Proc and gets to arguments:
  # 
  # * resource - This may be an user instance
  # * params   - A hash with callback parameters
  #     * sofort_token      - The users sofort_token
  #     * transaction_time  - A UNIX timestamp of the time the transaction
  #                           was successful.
  #     * amount            - The amount that was paid.
  #
  # Note: If prepaid_mode is true this could be omitted.
  mattr_writer    :on_transaction_success

  # The parent controller which the sofort controller should inherit from. 
  # Thsi defaults to 'ApplicationController' and should be a String.
  mattr_accessor :parent_controller
  @@parent_controller = 'ApplicationController'

  # 
  #
  # 
  mattr_accessor :resource_klass
  @@resource_klass = 'User'

  # Shortcut for the country where sofortueberweisung is used.
  # This is used within the form helpers. 
  # If country code is not allowed, a NotAllowedCountryError
  # is raised.
  def country=(country)
    unless ALLOWED_COUNTRIES.include?(country)
      raise Errors::NotAllowedCountryError.new, "not allowed country configured"
    end
    @country = country
  end

  # If country is not configured, it is taken from the Rails
  # locales config.
  def country
    @country ||= I18n.default_locale
  end

  def timeout 
    @@timeout ||= 120
  end

  def encryptor
    @@encryptor ||= :sha512
  end

  def stretches
    @@stretches ||= 128
  end

  def prepaid_mode
    @@prepaid_mode ||= false
  end

  def not_modifiable_params
    @@not_modifiable_params ||= []
  end

  def currency=(currency)
    unless ALLOWED_CURRENCIES.include?(currency)
      raise Errors::NotAllowedCurrencyError.new, "not allowed currency configured!" 
    end
    @currency = currency.upcase
  end

  def currency
    @currency
  end

  def reason(resource=nil)
    if resource.nil?
      return @@reason ||= "" 
    else
      if @@reason.is_a? Proc
        return @@reason.call(resource)
      else
        @@reason
      end
    end
  end

  def orm
    @@orm ||= :mongoid
  end

  def on_transaction_success
    unless defined? @@on_transaction_success
      Proc.new{|resource,params|}
    else
      return @@on_transaction_success 
    end
  end

  def setup(&block)
    yield self
  end

  # Include helpers in the given scope to AC and AV.
  def include_helpers(scope)
    ActiveSupport.on_load(:action_controller) do
      include scope::Helpers if defined?(scope::Helpers)
      #include scope::UrlHelpers
    end

    ActiveSupport.on_load(:action_view) do
      include scope::ViewHelpers
    end
  end
end

require "sofort/models"
require "sofort/rails"