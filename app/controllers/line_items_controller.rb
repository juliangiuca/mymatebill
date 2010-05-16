class LineItemsController < ApplicationController
  skip_before_filter :login_required, :only => [:show]

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

end
