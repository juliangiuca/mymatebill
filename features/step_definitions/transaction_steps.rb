Given /^I have an account$/ do
  @identity = Factory(:identity)
end

Given /^an association with (.*)$/ do |biller|
  @biller = @identity.associates.create!(:name => biller)
end

When /^A bill for \$(.*) arrives for me from Rent$/ do |amount|
  @transaction = @identity.transactions.create!(:amount => amount, :to => @biller, :from => @identity)
end

Then /^The transaction and steps should be linked to myself and Rent$/ do
  Transaction.all.length.should == 1
  @transaction.to.should == @biller
  @transaction.from.should == @identity
end

Then /^I should be the owner of the transaction$/ do
  @transaction.owner.should == @identity

  @identity.incoming_transactions.should have(0).record
  @identity.outgoing_transactions.should have(1).record

  @biller.incoming_transactions.should have(1).record
  @biller.outgoing_transactions.should have(0).record
end

Given /^A \$(.*) transaction between myself and (.*)$/ do |amount, biller|
   Given 'I have an account'
     And "an association with #{biller}"
    When "A bill for $#{amount} arrives for me from Rent"
end

Given /^A \$(.*) transaction from (.*) to (.*)$/ do |amount, from, biller|
   Given 'I have an account'
     And "an association with #{biller == "myself" ? from : biller}"
     if from == "myself"
       from_person = @identity
       to_person = @biller
     else
       from_person = @biller
       to_person = @identity
     end
    @transaction = @identity.transactions.create!(:amount => amount, :to => to_person, :from => from_person)
end

Given /^I confirm payment$/ do
  @transaction.confirm_payment!
end

Then /^(.*) should be \$(.*) poorer$/ do |person, amount|
  @identity.reload
  @biller.reload
  if person == "I"
    @identity.cash_out.should == (amount.to_i * -1)
  else
    @biller.cash_out.should == (amount.to_i * -1)
  end
end

Then /^(.*) should be \$(.*) richer$/ do |person, amount|
  if person == "I"
    @identity.cash_in.should == amount.to_i
  else
    @biller.cash_in.should == amount.to_i
  end
end

Given /^(.*) has an account$/ do |person|
  instance_variable_set("@#{person.downcase}", @identity.associates.create!(:name => person))
end

Given /^(.*) exists as a biller$/ do |biller|
  @biller = @identity.associates.create!(:name => biller)
end

When /^A bill for rent arrives for \$(.*)$/ do |amount|
  @amount = amount.to_i
  #the number of friends minus the biller plus me!
  number_of_friends = @identity.associates.length
  friends = @identity.associates.select{|x| x != @biller}
  amount_each = @amount / number_of_friends
  steps = friends.map {|associate| {:amount => amount_each, :to => @biller, :from => associate}}
  steps << {:amount => amount_each, :to => @biller, :from => @identity}
  @transaction = @identity.transactions.create!(:to => @biller,
                                              :description => "Rent",
                                              :steps_attributes => steps)
end

Then /^the bill should be created$/ do
  @transaction.reload
  @transaction.steps.should have(4).records
  @transaction.steps.first.transaction.should == @transaction

  Transaction.all.should have(1).records
  Step.all.should have(4).records
  Dealing.all.should have(5).records

  @transaction.from.should be_blank
  @transaction.to.should == @biller
  @transaction.amount.should == @amount
end

Then /^everyone should have to an bill for an equal share$/ do
  friends = @identity.associates.select{|x| x != @biller}
  number_of_friends = friends.length + 1
  friends.each do |friend|
    friend.outgoing_transactions.should have(1).records
    friend.outgoing_transactions.first.amount.should == @amount / number_of_friends
  end
  @identity.outgoing_transactions.should have(1).records
  @identity.outgoing_transactions.first.amount.should == @amount / number_of_friends
  @biller.incoming_transactions.should have(1).records
  @biller.incoming_transactions.first.amount.should == @amount
end

Given /^The complex transaction setup$/ do
   Given 'I have an account'
     And "Frog has an account"
     And "Rabbit has an account"
    And "Captain has an account"
    And "Rent exists as a biller"
   When "A bill for rent arrives for $1300"
   Then "the bill should be created"
end

When /^I add (.*) to the bill for \$(.*)$/ do |associate_name, amount|
  associate = @identity.associates.find_by_name(associate_name)
  @transaction.steps.create!(:to => @biller, :from => associate, :amount => amount)
end

Then /^The bill should be updated to \$(.*)$/ do |amount|
  @transaction.reload
  @transaction.amount.should == amount.to_i
end

When /^I remove (.*) from the transaction$/ do |associate_name|
  associate = @identity.associates.find_by_name(associate_name)
  associate.outgoing_transactions.first.delete
end

When /^I remove (.*) from the transaction step$/ do |associate_name|
  associate = @identity.associates.find_by_name(associate_name)
  @transaction.steps.find_by_from_associate_id(associate.id).delete
end

When /^I remove the bill$/ do
  @transaction.reload
  @transaction.destroy
end

Then /^All the steps and balances are removed too$/ do
  Transaction.all.should have(0).records
  Step.all.should have(0).records
  @biller.incoming_transactions.should be_blank
end

When /^I remove the steps to a bill$/ do
  @transaction.steps.each do |step|
    step.destroy
  end
end

When /^I confirm all the steps in a bill$/ do
  @transaction.steps.each do |step|
    step.confirm_payment!
  end
end

Then /^The transaction is automatically marked as paid and balances set$/ do
  @transaction.reload
  @transaction.state.should == "paid"
  @transaction.steps.map{|x| x.state}.count("paid").should == 4
  @biller.reload
  @biller.cash_in = 1300

  @identity.reload
  friends = @identity.associates.select{|x| x != @biller}
  number_of_friends = friends.length + 1
  friends.each do |friend|
    friend.outgoing_transactions.should have(1).records
    friend.outgoing_transactions.first.amount.should == @amount / number_of_friends
    #friend.cash_out.should == (@amount / number_of_friends) * -1
    friend.cash_out.should == 0
  end
end

When /^I confirm the transaction$/ do
  @transaction.confirm_payment!
end

