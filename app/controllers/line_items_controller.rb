class LineItemsController < ApplicationController
   layout "leftnav"

   def index
     @line_items = current_user.line_items
   end

   def show
   end
end
