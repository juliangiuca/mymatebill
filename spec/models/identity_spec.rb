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
    #account.identity.create!(:name => "Trevor")
    #Identity.first.should_not be_nil
    #Account.find(account.id).identity.should be_present
    #account.identity.should have(2).record
  end

  it "should be able to create friends" do
    account = Factory(:account)
    identity = account.identity
    identity.associates.create!(:name => "Trevor")
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

  #describe "friends being deleted with transactions" do
    #before(:each) do
      #@user = Factory(:entity)
      #@account = Factory(:account, :account_id => @user.id)
      #@friend_1_receiving = Factory(:friend, :account_id => @user.id)
      #@transaction_to_someone = Factory(:transaction, :recipient_id => @friend_1_receiving.id, :amount => "20")
      #Transaction.find(@transaction_to_someone.id).line_items.should have(1).record

      #@friend_2_giving = Factory(:friend, :user_id => @user.id)
      #@transaction_from_someone = @account.transactions.new(:amount => "50")
      #@transaction_from_someone.recipient_id = @user.myself_as_a_friend.id
      #@transaction_from_someone.line_items.build(:amount => "50", :friend_id => @friend_2_giving.id)
      #@transaction_from_someone.save!
      #Transaction.find(@transaction_from_someone.id).line_items.should have(1).record

      #@user.reload
      #@user.myself_as_a_friend.credit.should == 50
      #@user.myself_as_a_friend.debt.should == -20
      #@user.visible_friends.should have(2).records
    #end

    #it "should delete any transactions when a friend is deleted" do
      #@user.myself_as_a_friend.transactions.should have(1).records
      ##@friend_1_receiving.destroy
      ##@user.reload
      ##@user.myself_as_a_friend.debt.should == 0
      #@friend_2_giving.destroy
      #@user.reload
      #@user.myself_as_a_friend.credit.should == 0
    #end

    #it "should reset any funds when a friend is deleted"
  #end

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

