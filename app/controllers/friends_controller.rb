class FriendsController < ApplicationController
  layout "leftnav"

  def index
    @friends = current_user.visible_friends
  end

  def show
    @friend = current_user.friends.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to :action => "index"
  end

  def new
    @friend = current_user.friends.new
  end

  def edit
    @friend = current_user.friends.find(params[:id])
    raise ActiveRecord::RecordNotFound unless @friend

  end

  def create
    @friend = current_user.friends.new(params[:friend])
    if @friend && @friend.valid? && @friend.save! && @friend.errors.empty?
      redirect_to :action => "index"
    else
      render :action => "new"
    end
  end
end
