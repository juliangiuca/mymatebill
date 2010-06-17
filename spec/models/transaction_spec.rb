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
  end

  #it "should have an owner" do
    #transaction = @identity.transactions.create!(:description => "test transaction", :amount => "80", :from => @frog, :to => @identity)
    #transaction.owner.should == @identity
  #end

  #it "should have a 'to'" do
    #transaction = @identity.transactions.create!(:description => "test transaction", :amount => "80", :from => @frog, :to => @identity)
    #transaction.to.should == @identity
  #end

  #it "should have a 'from'" do
    #transaction = @identity.transactions.create!(:description => "test transaction", :amount => "80", :from => @frog, :to => @identity)
    #transaction.from.should == @frog
  #end

  #it "should have a 'from'" do
    #transaction = @identity.transactions.create!(:description => "test transaction", :amount => "80", :from => @frog, :to => @identity)
    #transaction.amount.should == 80
  #end

  #it "should create a self referencing line item" do
    #transaction = @identity.transactions.create!(:description => "test transaction", :amount => "80", :from => @frog, :to => @identity)
    #transaction.steps.should be_present
    #transaction.steps.should have(1).record
    #transaction.steps.last.amount.should == 80
  #end

  #describe "for simple two person transactions" do

    #it "Frog owes me $20" do
      #transaction = @identity.transactions.new(:description => "Frog owes me $20",
                              #:amount => 20,
                              #:from => @frog,
                              #:to => @identity)
      #transaction.save!
      #transaction.confirm_payment!

      #@identity.cash_in.should == 20
      #@frog.reload
      #@frog.cash_out.should == -20
    #end

     #it "I owe Frog $20" do
      #transaction = @identity.transactions.create!(:description => "I owe Frog $20",
                              #:amount => 20,
                              #:to => @frog,
                              #:from => @identity)

      #transaction.confirm_payment!

      #@identity.cash_out.should == -20
      #@frog.reload
      #@frog.cash_in.should == 20

    #end

  #end

  #describe "transaction states" do
    #before(:each) do
      #@transaction = @identity.transactions.create!(:description => "I owe Frog $20",
                              #:amount => 20,
                              #:to => @frog,
                              #:from => @identity)

    #end
    #it "should transition from unpaid to paid" do
      #@transaction.confirm_payment!
      #Transaction.last.paid?.should be_true
    #end

    #it "should transition from paid to unpaid"

    #it "should transition to paid when being deleted" do
      #@transaction.destroy
      #Transaction.all.should be_blank
    #end
  #end

  #it "should mark all line_items as paid when setting a transaction to paid"
  #it "should automatically be set to paid when all line_items are paid"

  describe "for multi person transactions" do
    before(:each) do
      @transaction = @identity.transactions.new
      @transaction.description = "Test description"
      @transaction.amount = "123"
      @transaction.to = @identity
      @transaction.from = @frog

      #line item
      line_item = @transaction.steps.build
      line_item.to = @identity
      line_item.from = @rabbit
      line_item.amount = "12"

      @transaction.save!
      @transaction.reload
    end

    #it "should have two steps and one summary" do
      #Transaction.find(@transaction.id).steps.should be_present
      #@transaction.steps.should have(2).record
      #@transaction.steps.first.summary.should == @transaction
      #Transaction.all.should have(3).records
    #end

    it "should tally the sum of the steps" do
      @transaction.amount.should == 135
    end

    #it "should update the tally when a new step is added" do
      #@transaction.steps.create!(:to => @identity, :from => @frenchie, :amount => "14")
      #@transaction.reload
      #@transaction.amount.should == 149
    #end

    #it "should update the tally then a step is removed"
    #it "should remove itself when all steps are removed"

    #it "should set the summary to be blank" do
      #@transaction.from.should be_blank
    #end

    #it "should set the summary from blank to the last step when steps are removed"
  end
end
