class LineItemsController < ApplicationController
  skip_before_filter :login_required, :only => [:show, :update_line_item_status]

  layout "leftnav"

  def index
    @line_items = current_user.myself_as_a_friend.line_items.find_by_state(params[:id])
    render :action => :show, :id => "unpaid"
  end

  def show
    raise ActiveRecord::RecordNotFound unless LineItem.aasm_states.map(&:name).include?(params[:id].to_sym)

    @line_items = current_user.myself_as_a_friend.line_items.find_all_by_state(params[:id])

  rescue ActiveRecord::RecordNotFound
    redirect_to transaction_path if current_user
    redirect_to login_path
  end

  def update_status
    @line_item = LineItem.find_by_unique_magic_hash(params["id"])
    object_to_update = params['object_to_update']
    raise ActiveRecord::RecordNotFound unless @line_item && object_to_update

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

    render(:update) { |page| page.replace_html object_to_update, :partial => "/shared/line_item", :object => @line_item }

  rescue ActiveRecord::RecordNotFound
  end
end
