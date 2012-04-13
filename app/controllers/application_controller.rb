class ApplicationController < ActionController::Base
  protect_from_forgery
  # TODO
  #check_authorization
  rescue_from CanCan::AccessDenied do |exception|
    #logger.debug exception
    redirect_to root_url, :alert => exception.message
  end
  def current_ability
    @current_ability ||= Ability.new(current_user)
  end
  rescue_from NameError do |error|
    puts error
    Router.reload
  end

  private
  def not_authenticated
    redirect_to login_url
  end
end
