class VisitorController < ApplicationController
  layout "basic"

  skip_before_filter :login_required, :only => [:show, :update_line_item_status]

  def show
    @friend = Friend.find_by_unique_magic_hash(params[:id])
  end
end
