require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Identity do
  before(:each) do
    @valid_attributes = {
      :account_id => 1,
      :name => "friendly person"
    }
  end

  it "should create a new instance given valid attributes" do
    Identity.create!(@valid_attributes)
  end

  it "should be able to be created a default identity attached to a user" do
    account = Factory(:account)
    account.identity.should be_present
    Identity.first.should_not be_nil
    Account.find(account.id).identity.should be_present
  end

  it "should be find itself when looking for me as a friend" do
    account = Factory(:account)
    account.identity.should be_present
    Identity.first.should_not be_nil
    account.identity.associates.find_or_create_by_name(account.identity.name).should == account.identity
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

  it "should create a hash" do
    friend_1 = Identity.create!(:name => "albert", :account_id => 1)
    Identity.find(friend_1.id).unique_magic_hash.should_not be_nil
  end

  #FOR THE LOVE OF GOD WHY?!?!
  #it "should ensure the hash is unique in a sample of 200" do
  # loop_counter = 200
  # loop_counter.times do |t|
  #   Identity.create!(:name => "albert", :account_id => t)
  # end
  # Identity.calculate(:count, :unique_magic_hash, :distinct => true).should == loop_counter
  #end

  it "should not have leading and trailing spaces in its name" do
    friend = Identity.create!(:name => " spacy name ", :account_id => 1)
    friend.name.should == friend.name.strip
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

# == Schema Information
#
# Table name: friends
#
#  id                :integer(4)      not null, primary key
#  owner_id          :integer(4)
#  user_id           :integer(4)
#  name              :string(255)
#  credit            :float           default(0.0)
#  debt              :float           default(0.0)
#  pending           :float           default(0.0)
#  total             :float
#  befriended_on     :date
#  unique_magic_hash :string(255)
#  email_address     :string(255)
#  hidden            :boolean(1)      default(FALSE)
#

