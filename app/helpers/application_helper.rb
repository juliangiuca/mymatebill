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
end
