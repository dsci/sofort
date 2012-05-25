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

  autoload :Errors, 'sofort/errors'

  module Credentials
    autoload :Facade, 'sofort/credentials/facade'
  end

  module Encryptors
    autoload :BaseEncryptor, 'sofort/crypt/base'
  end

  ALLOWED_CURRENCIES    = [:eur,:chf,:pln, :gbp]
  ALLOWED_COUNTRIES     = [:de,:ch, :at]
  ALLOWED_ORM_ADAPTERS  = [:mongoid]

  #############################################################################
  # Required configuration fields                                             #
  #############################################################################

  # Parameters which are not modifiable by user. 
  # They are configured at sofortueberweisung.de
  mattr_accessor  :not_modifiable_params

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
      raise Errors::NotAllowedORMAdapterError.new, "#{orm.to_s} is currently not supported."
    end
    require "sofort/orm/#{orm.to_s}"
  end

  #############################################################################
  # Optional configuration fields                                             #
  #############################################################################

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

  # A number which length the sofort_credential attribute 
  # should have. Default to 128.
  mattr_writer    :stretches

  # A flag if a prepaid_mode or 'coin' mode should be used.
  # If it is true, 'sofort' updates the users balance. 
  # 
  mattr_writer    :prepaid_mode

  # Shortcut for the country where sofortueberweisung is used.
  # This is used within the form helpers. 
  # If country code is not allowed, a NotAllowedCountryError
  # is raised.
  def country=(country)
    unless ALLOWED_COUNTRIES.include(country)
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
    @timeout ||= 120
  end

  def encryptor
    @encryptor ||= :sha512
  end

  def stretches
    @stretches ||= 128
  end

  def prepaid_mode
    @prepaid_mode ||= false
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

  def setup(&block)
    yield self
  end

end

require "sofort/rails"
require "sofort/models"