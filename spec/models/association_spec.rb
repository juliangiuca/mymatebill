require 'spec_helper'

describe Association do
  before(:each) do
    @valid_attributes = {
      
    }
  end

  it "should create a new instance given valid attributes" do
    Association.create!(@valid_attributes)
  end

  it "should be able to create friends" do
    account = Factory(:account)
    identity = account.identity
    identity.associates.create!(:name => "Trevor")
    Identity.should have(2).records
    identity.associates.length.should == 1
  end
  
  it "should be able to create friends through a find_or_create_by_name" do
    account = Factory(:account)
    identity = account.identity
    identity.associates.find_or_create_by_name("Trevor")
    identity.associates.find_or_create_by_name("Trevor")
    Identity.should have(2).records
    identity.associates.length.should == 1
  end
  
  it "should handle the deletion of friends"

  describe "friends being deleted with transactions" do
    before(:each) do
      @identity = Factory(:identity)
      @friend_1_receiving = @identity.associates.create!(:name => "Frog")
      @transaction_to_someone = @identity.transactions.create!(:to => @friend_1_receiving, :amount => "20", :from => @identity)
      Transaction.find(@transaction_to_someone.id).steps.should have(1).record


      @friend_2_giving = @identity.associates.create!(:name => "Captain")
      @transaction_from_someone = @identity.transactions.new(:amount => "50")
      @transaction_from_someone.to = @identity
      @transaction_from_someone.steps.build(:amount => "50", :from => @friend_2_giving, :to => @identity)
      @transaction_from_someone.save!
      Transaction.find(@transaction_from_someone.id).steps.should have(1).record

      @identity.reload
      @identity.future_cash_in.should == 50
      @identity.future_cash_out.should == -20
      @identity.associates.should have(2).records
    end

    it "should delete any transactions when a friend is deleted" do
      @identity.transactions.should have(2).records
      #@friend_1_receiving.destroy
      #@user.reload
      #@user.myself_as_a_friend.debt.should == 0
      @friend_2_giving.destroy
      @identity.reload
      @identity.cash_in.should == 0
      @identity.cash_out.should == 0
      @identity.future_cash_in.should == 0
      @identity.future_cash_out.should == -20
    end

    it "should reset any funds when a friend is deleted"
  end
  
end
