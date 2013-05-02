# Dirty hack. Has to be replaced. Rails didn't autoload SofortController
# 
require File.expand_path(File.join(File.dirname(__FILE__), '..', 'sofort'))

class Sofort::CallbackController < SofortController

  # Public: Evaluates the callback. 
  # 
  # Awaits the following params:
  # 
  # * amount        - The amount which was send in the transaction
  # * sofort_token  - The users sofort_token which was generated 
  #                   before the transaction and was send with 
  #                   the transaction
  # * timestamp     - Unix timestamp of the transaction
  def cb
    sofort_token  = params[:sofort_token]
    amount        = params[:amount]
    timestamp     = params[:timestamp]

    user        = nil
    token_valid = false
    if defined?(current_user)
      user = current_user
      token_valid = user.sofort_token.eql?(sofort_token)
      #token = Sofort::Encryptors::Base.valid?(sofort_token, Sofort::Credentials::Facade.new(user))
    else 
      user = Sofort.resource_class.constantize.send(:find_by_user_token, sofort_token)
      raise Sofort::Errors::NoUserFoundWithTokenError.new, I18n.t('sofort.transaction.failed.missing_user') if user.nil?
      token_valid = user.sofort_token.eql?(sofort_token)
    end

    raise Sofort::Errors::InvalidTokenFoundError.new, I18n.t('sofort.transaction.failed.invalid_token') unless token_valid
    
    if token_valid
      # call any user hook here
      Sofort.on_transaction_success.call(user, params) unless Sofort.on_transaction_success.nil?
      respond_to do |format|
        format.json do
          render :json => @user
        end
        format.html do
          flash[:notice] = I18n.t('sofort.transaction.success')
          redirect_to root_url
        end 
      end
    end

  end

end