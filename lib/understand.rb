require "treetop"
require 'oweing'

class Understand
  def self.transaction(current_user, string)
    parser = OweingParser.new
    parsed_string = parser.parse(string).try(:content)

    if parsed_string
      %w(creditor debitor).each do |role|
        if %w(I my me myself).include?(parsed_string[role.to_sym])
          instance_variable_set("@#{role}", current_user.myself_as_a_friend)
        else
          instance_variable_set("@#{role}", current_user.friends.find_by_name(parsed_string[role.to_sym]))
        end
      end
      amount            = parsed_string[:amount]
      unfound_creditor  = parsed_string[:creditor]
      unfound_debitor   = parsed_string[:debitor]
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
