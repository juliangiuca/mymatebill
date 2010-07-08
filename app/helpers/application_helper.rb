# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def change_state_link(line_item)
    output = String.new

    if line_item.mine?
      output += "#{line_item.state} - "
      if line_item.transaction.mine?
        output += "pay & close" if !line_item.paid?
      else
        output += "pay" if !line_item.paid?
        output += "unpay" if (line_item.paid? || line_item.pending?)
      end
    else
      output += "#{line_item.state}"
      if line_item.transaction.mine?
        output += " - "
        output += "mark as recieved" if !line_item.paid?
        output += "mark as unpaid" if line_item.paid?
      end
    end

    return output
  end

  def line_item_state(object, object_to_update)
    output = String.new
    #if object.mine?
      #output += "Mark as paid" if !object.paid?
      #output += "Mark as unpaid" if object.paid?
    #else
      #output += "Mark as received" if !object.paid?
      #output += "Mark as unpaid" if object.paid?
    #end
    return link_to_remote(object.state, 
          :url => {
                  :action => "update_line_item_status",
                  :id => object.unique_magic_hash,
                  :object_to_update => object_to_update
                  })
  end

  def is_it_me(friend)
    if current_user && current_user.myself_as_a_friend == friend
     "Me"
    else
      (friend.try(:owner) || friend).name.capitalize
    end
  end

  def date_style(date)
    date.to_date.strftime("%d.%m.%y")
  end

end
