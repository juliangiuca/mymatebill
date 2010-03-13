class FriendsController < ApplicationController
  layout "leftnav"

  def index
    @friends = current_user.friends
  end

  def show
    @friend = current_user.friends.find(params[:id])
  end
end
