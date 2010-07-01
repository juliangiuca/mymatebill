# == Schema Information
# Schema version: 20091211224549
#
# Table name: transactions
#
#  id                :integer(4)      not null, primary key
#  description       :string(255)
#  account_id        :integer(4)
#  due               :date
#  actor_id          :integer(4)
#  amount            :float
#  state             :string(255)
#  recipient_id      :integer(4)
#  unique_magic_hash :string(255)
#  created_at        :datetime
#  updated_at        :datetime
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Transaction do
  before(:each) do
    @identity = Factory(:identity)
    @frog = @identity.associates.create!(:name => "Frog")
    @rabbit = @identity.associates.create!(:name => "Rabbit")
    @frenchie = @identity.associates.create!(:name => "Frenchie")
    @rent = @identity.associates.create!(:name => "Rent")
  end

  it "should have an owner" do
    transaction = @identity.transactions.create!(:description => "test transaction", :amount => "80", :from => @frog, :to => @identity)
    transaction.owner.should == @identity
  end

  it "should have a 'to'" do
    transaction = @identity.transactions.create!(:description => "test transaction", :amount => "80", :from => @frog, :to => @identity)
    transaction.to.should == @identity
  end

  it "should have a 'from'" do
    transaction = @identity.transactions.create!(:description => "test transaction", :amount => "80", :from => @frog, :to => @identity)
    transaction.from.should == @frog
  end

  it "should have a 'from'" do
    transaction = @identity.transactions.create!(:description => "test transaction", :amount => "80", :from => @frog, :to => @identity)
    transaction.amount.should == 80
  end

  it "should create a self referencing line item" do
    transaction = @identity.transactions.create!(:description => "test transaction", :amount => "80", :from => @frog, :to => @identity)
    transaction.steps.should be_present
    transaction.steps.should have(1).record
    transaction.steps.last.amount.should == 80
  end

  describe "transaction states" do
    before(:each) do
      @transaction = @identity.transactions.create!(
        :description => "I owe Frog $20",
        :amount => 20,
        :to => @frog,
        :from => @identity
      )
    end

    it "should transition from unpaid to paid" do
      @transaction.confirm_payment!
      Transaction.last.paid?.should be_true
    end

    it "should transition from paid to unpaid" do
      @transaction.confirm_payment!
      @transaction.unpay!
      Transaction.last.paid?.should be_false
    end

    it "should transition to paid when being deleted" do
      @transaction.destroy
      Transaction.all.should be_blank
    end
  end

end
