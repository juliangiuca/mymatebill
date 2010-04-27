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

  def update
    @friend = current_user.friends.find(params[:id])
    @friend.update_attributes(params[:friend])
    @friends = current_user.friends
    render :action => :index
  end

  def create
    @friend = current_user.friends.new(params[:friend])
    if @friend && @friend.valid? && @friend.save! && @friend.errors.empty?
      redirect_to :action => "index"
    else
      render :action => "new"
    end
  end

  def destroy
    @friend = current_user.friends.find(params[:id]).destroy
    render :partial => "del_friend", :object => @friend
  rescue
    render :partial => "something_broke", :status => :error
  end
end
