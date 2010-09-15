require 'spec_helper'

describe RecurringTransaction do
  before(:each) do
  end

  it "should have the correct next" do
    recurring_transaction = Factory(:recurring_transaction, :start_date => Date.today.monday, :end_date => Date.today + 100.years, :rec_type => 'weekly_6_2')
    recurring_transaction.next_transaction.due.should == Date.today.monday + 5.days + 2.weeks
    
    # Teh 14th of every month
    recurring_transaction.start_date = Date.today.beginning_of_month + 1.month
    recurring_transaction.rec_type = "monthly_14_1"
    recurring_transaction.next_transaction.due.should == Date.today.beginning_of_month + 1.month + 13.days
    
    recurring_transaction.start_date = Date.today.beginning_of_month
    recurring_transaction.rec_type = "monthly_14_2"
    recurring_transaction.next_transaction.due.should == Date.today.beginning_of_month + 2.months + 13.days
  end
end
