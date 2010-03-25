# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def change_state_link(line_item)
    output = String.new

    if line_item.mine?
      output += "#{line_item.state} - "
      output += "pay & close" if !line_item.paid? && line_item.transaction.mine?
      output += "pay" if !line_item.paid? && !line_item.transaction.mine?
      output += "unpay" if (line_item.paid? || line_item.pending?) && !line_item.transaction.mine?
    else
      output += "#{line_item.state} - "
      output += "mark as recieved" if !line_item.paid?
      output += "mark as unpaid" if line_item.paid?
    end

    return output
  end
end
