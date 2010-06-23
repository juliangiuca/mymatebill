require "treetop"
require 'oweing'

class Understand
  def self.transaction(current_user, string)
    parser = OweingParser.new
    parsed_string = parser.parse(string).try(:content)
    @creditor = nil
    @debitor = nil

    if parsed_string
      %w(creditor debitor).each do |role|
        if %w(i my me myself).include?(parsed_string[role.to_sym].downcase)
          instance_variable_set("@#{role}", current_user)
        else
          instance_variable_set("@#{role}", current_user.associates.find_by_name(parsed_string[role.to_sym]))
        end
      end #end role loop
      amount            = parsed_string[:amount]
      unfound_creditor  = parsed_string[:creditor] unless @creditor
      unfound_debitor   = parsed_string[:debitor] unless @debitor
      description       = parsed_string[:description]
    end

    return {:in_debt => @debitor.try(:name),
            :unknown_in_debt => unfound_debitor,
            :in_credit => @creditor.try(:name),
            :unknown_in_credit => unfound_creditor,
            :amount => amount,
            :description => description}
  end
end
