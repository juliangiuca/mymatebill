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
      amount = parsed_string[:amount]
      @creditor ||= {:name => parsed_string[:creditor]}
      @debitor ||= {:name => parsed_string[:debitor]}
      description = parsed_string[:description]
    end

    return {:in_debt => @debitor.try(:name), :in_credit => @creditor.try(:name), :amount => amount, :description => description}
  end
end
