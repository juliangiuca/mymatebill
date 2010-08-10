When /^I delete (.*)$/ do |associate_name|
  @identity.reload
  associate = @identity.associates.find_by_name(associate_name)
  associate.destroy
end

Then /^the transaction should be removed$/ do
  @identity.reload
  Transaction.all.should have(0).records
end

Then /^all debts should be reset$/ do
  @identity.reload
  @identity.cash_in.should == 0
  @identity.cash_out.should == 0
  @identity.future_cash_in.should == 0
  @identity.future_cash_out.should == 0
end

