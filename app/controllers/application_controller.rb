# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include ExceptionNotifiable
  include AuthenticatedSystem

  before_filter :login_required
  before_filter :set_models_current_user

  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  def set_models_current_user
    ActiveRecord::Base.current_user = current_user
  end
end
