class LineItemsController < ApplicationController
  skip_before_filter :login_required, :only => [:show, :update_line_item_status]
  skip_before_filter :set_current_user, :only => [:show, :update_line_item_status]

  layout "leftnav"

  def index
    @line_items = current_user.line_items
  end

  def show
    @line_item = LineItem.find_by_unique_magic_hash(params["id"])
    raise ActiveRecord::RecordNotFound unless @line_item

    @event = @line_item.event
    @friend = @line_item.friend
    @owner = @line_item.event.account.user

  rescue ActiveRecord::RecordNotFound
    redirect_to login_path
  end

  def update_line_item_status
    @line_item = LineItem.find_by_unique_magic_hash(params["id"])
    raise ActiveRecord::RecordNotFound unless @line_item

    if @line_item.pending?
      @line_item.unpay!
    elsif @line_item.unpaid?
      @line_item.pay!
    end

    @event = @line_item.event
    @friend = @line_item.friend
    @owner = @line_item.event.account.user

    render(:update) { |page| page.replace_html "bill_status", :partial => "line_item_status"  }

  rescue ActiveRecord::RecordNotFound
  end
end
