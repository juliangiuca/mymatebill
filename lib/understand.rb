require "treetop"
require 'oweing'

class Understand
  attr_accessor :in_debt, :unknown_in_debt, :in_credit, :unknown_in_credit, :amount, :description, :success
  def self.transaction(current_user, string)
    parser = OweingParser.new
    parsed_string = parser.parse(string).try(:content)
    @creditor = nil
    @debitor = nil
    understood = self.new
    understood.success = false

    if parsed_string
      #A role is a creditor or a debitor
      %w(creditor debitor).each do |role|
        #it's defining who is the creditor/debitor based from the I/my/me/myself
        if %w(i my me myself).include?(parsed_string[role.to_sym].downcase)
          instance_variable_set("@#{role}", current_user)
        else
          instance_variable_set("@#{role}", current_user.associates.find_by_name(parsed_string[role.to_sym]))
        end
      end #end role loop
      understood.amount            = parsed_string[:amount]
      understood.in_credit         = @creditor.try(:name)
      understood.unknown_in_credit = parsed_string[:creditor] unless @creditor
      understood.in_debt           = @debitor.try(:name)
      understood.unknown_in_debt   = parsed_string[:debitor] unless @debitor
      understood.description       = parsed_string[:description]
      understood.success           = true
    end

    #return {:in_debt => @debitor.try(:name),
            #:unknown_in_debt => unfound_debitor,
            #:in_credit => @creditor.try(:name),
            #:unknown_in_credit => unfound_creditor,
            #:amount => amount,
            #:description => description,
            #:success => success}
    return understood || self.new
  end

  def success?
    return success
  end
end
