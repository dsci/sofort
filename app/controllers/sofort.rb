class SofortController < Sofort.parent_controller.constantize

  rescue_from Sofort::Errors::NoUserFoundWithTokenError do |exception|
    handle_error(exception.message)
  end
  
  rescue_from Sofort::Errors::InvalidTokenFoundError do |exception|
    handle_error(exception.message)
  end

  def handle_error(message)
    respond_to do |format|
      format.json do
        render :json => {:success => false, :error => message}
      end
      format.html do
        flash[:error] = message
        redirect_to root_url
      end
    end
  end

  protected 

  def validate_token(resource,token)
    values_holder = Sofort::Credentials::Facade.new(resource)
    Sofort::Encryptors::Base.valid?(token,values_holder)
  end

end