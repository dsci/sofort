Sofort.setup do |config|

  config.customer_id  = 2347

  config.project_id   = 111234 

  config.country      = :de

  config.orm          = :mongoid

  config.not_modifiable_params = [:account_number, :holder]

end