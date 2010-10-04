class AssociatesController < ApplicationController
  layout "default"

  def index
    @friends = current_user.associates
    @title = "Friends"
  end

  def show
    @friend = current_user.associates.find(params[:id])
    @title = @friend.name
  rescue ActiveRecord::RecordNotFound
    redirect_to :action => "index"
  end

  def new
    @friend = current_user.associates.new
  end

  def edit
    @friend = current_user.associates.find(params[:id])
    @title = @friend.name
    raise ActiveRecord::RecordNotFound unless @friend
  end

  def update
    @friend = current_user.associates.find(params[:id])
    @friend.update_attributes(params[:friend])
    @friends = current_user.associates
    render :action => :index
  end

  def create
    @friend = current_user.associates.new(params[:friend])
    if @friend && @friend.valid? && @friend.save! && @friend.errors.empty?
      redirect_to :action => "index"
    else
      render :action => "new"
    end
  end

  def destroy
    @friend = current_user.associates.find(params[:id])
    raise ActiveRecord::RecordNotFound unless @friend

    @friend.destroy
    render :partial => "del_friend", :object => @friend
  rescue ActiveRecord::RecordNotFound
    render :partial => "friend", :status => :error, :object => @friend
  end
end
