class FriendsController < ApplicationController
  layout "leftnav"

  def index
    @friends = current_user.friends
  end

  def show
  end
end
