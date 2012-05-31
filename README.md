# sofort

## Getting started

Create a file called <code>sofort.rb</code> in your <code>config/initializers</code> directory.

```ruby
Sofort.setup do |config|

  #############################################################################
  # Required configuration fields                                             #
  #############################################################################

  # User or customer id at sofortueberweisung.de
  customer_id = 123456

  # The project id for which the payment should be done. 
  # Any id registered at sofortueberweisung.de
  project_id  = 555555

  # The project credentials, like sofortueberweisung say
  # 'Projekt-Passwort'. 
  # This is required by 'sofort' and not optional. 
  project_credentials = "aqwert162hbhaQ|p)s"

  # The response credentials, like sofortueberweisung say
  # 'Benachrichtigungspassword'.
  # This is required by 'sofort' and not optional.
  response_credentials = "s.hdg7823iuhfs.cdqw0"

  #############################################################################
  # Optional configuration fields                                             #
  #############################################################################

  # Parameters which are not modifiable by user. 
  # They are configured at sofortueberweisung.de
  #
  # Possible entries are:
  # :account_number,:bank_code, :holder, :user_country_id,:country_id
  # not_modifiable_params = [:account_number]

  # A database attribute field at the User model. 
  # Note that 'sofort' requires a current_user method
  # which returns an instance of the actual logged in
  # user.
  # This is an optional field and only used if 
  # prepaid_mode is true
  # user_balance = :amount
  
  # A custom encryptor which have to available through
  # 'digest/sha2'
  # Currently supported are sha256 and sha512, whereby 
  # sha512 is the default one. 
  # encryptor = :sha256

  # 
  # timeout = 200

  # A number which length the sofort_token attribute 
  # should have. Default to 128.
  # stretches = 13

  # A flag if a prepaid_mode or 'coin' mode should be used.
  # If it is true, 'sofort' updates the users balance. 
  # 
  # :prepaid_mode = true

  # A 'Verwendungszweck' which is used as a suffix before users
  # email to identify the payment. 
  # 
  # This is could be a string or a Proc. If you're using a proc,
  # be sure to add an argument to it:
  #
  # reason = proc {|resource| resource.email}
  # 
  # resource may be an instance of User.  
  # 
  # Defaults to an empty string.
  # reason = "My awesome shop order"

  # Shortcut for the country where sofortueberweisung is used.
  # This is used within the form helpers. 
  # If country code is not allowed, a NotAllowedCountryError
  # is raised. 
  # It defaults to I18n.default_locale
  # country = :at

end
```

Currently **sofort** only supports mongoid.

Add the additional methods to your user class, e.g. <code>app/models/user.rb</code>

```ruby
class User
  include Mongoid::Document

  sofort # <= add this line

```

This gives you access to the following additional attributes:

* bank_code
* account_number
* holder (should be optional)
* sofort_token

<code>sofort_token</code> is a random string which prevents CRSF attacks while
a connection is established between your app and sofortueberweisung.de|at|ch

## Contributing to sofort
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it.
* Fork the project.
* Start a feature/bugfix branch.
* Commit and push until you are happy with your contribution.
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright (c) 2012 Daniel Schmidt. See LICENSE.txt for
further details.

