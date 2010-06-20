# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include ExceptionNotifiable
  include AuthenticatedSystem

  before_filter :login_required
  before_filter :set_current_user
  skip_before_filter :login_required, :only => [:update_line_item_status]

  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  #
  def update_line_item_status
    line_item = LineItem.find_by_unique_magic_hash(params["id"])
    object_to_update = params['object_to_update']
    raise ActiveRecord::RecordNotFound unless line_item && object_to_update

    if line_item.mine?
      if line_item.paid?
        line_item.unpay!
      elsif !line_item.paid?
        line_item.confirm_payment!
      end
    else
      if !line_item.paid?
        line_item.confirm_payment!
      elsif line_item.paid?
        line_item.unpay!
      end
    end

    transaction = line_item.transaction
    friend = line_item.friend
    owner = line_item.transaction.account.user

    render(:update) { |page| page.replace_html object_to_update, :partial => "line_item_details", :object => line_item }

  rescue ActiveRecord::RecordNotFound
  end

end
