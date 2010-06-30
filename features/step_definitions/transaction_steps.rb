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
end

Given /^A \$(.*) transaction between myself and (.*)$/ do |amount, biller|
   Given 'I have an account'
     And "an association with #{biller}"
    When "A bill for $#{amount} arrives for me from Rent"
end

Given /^A \$(.*) transaction from (.*) to (.*)$/ do |amount, from, biller|
   Given 'I have an account'
     And "an association with #{biller}"
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


