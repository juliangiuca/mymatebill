When /^I unpay a step in a transaction$/ do
  @transaction.reload
  @transaction.steps.first.unpay!
end

Then /^The transaction is automatically marked as unpaid and balances set$/ do
  @transaction.reload
  @transaction.state.should == "unpaid"
  @transaction.steps.map{|x| x.state}.count("paid").should == 3
  @biller.cash_in = 975

  friends = @identity.associates.select{|x| x != @biller}
  number_of_friends = friends.length + 1
  friends.each do |friend|
    friend.outgoing_transactions.should have(1).records
    friend.outgoing_transactions.first.amount.should == @amount / number_of_friends
  end
end

