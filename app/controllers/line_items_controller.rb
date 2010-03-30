class LineItemsController < ApplicationController
  skip_before_filter :login_required, :only => [:show, :update_line_item_status]

  layout "basic"

  def index
    @line_items = current_user.line_items
  end

  def show
    @line_item = LineItem.find_by_unique_magic_hash(params["id"])
    raise ActiveRecord::RecordNotFound unless @line_item

    @transaction = @line_item.transaction
    @friend = @line_item.friend
    debugger
    @friend.update_attribute(:owner_id, current_user.id)
    @owner = @line_item.transaction.account.user

  rescue ActiveRecord::RecordNotFound
    redirect_to login_path
  end

  def update_line_item_status
    @line_item = LineItem.find_by_unique_magic_hash(params["id"])
    counter = params['counter'] || 0
    raise ActiveRecord::RecordNotFound unless @line_item

    if @line_item.mine?
      if @line_item.paid?
        @line_item.unpay!
      elsif !@line_item.paid?
        @line_item.pay!
      end
    else
      if !@line_item.paid?
        @line_item.confirm_payment!
      elsif @line_item.paid?
        @line_item.unpay!
      end
    end

    @transaction = @line_item.transaction
    @friend = @line_item.friend
    @owner = @line_item.transaction.account.user

    render(:update) { |page| page.replace_html "line_item_#{counter}", :partial => "/shared/line_item_details", :object => @line_item }

  rescue ActiveRecord::RecordNotFound
  end
end
