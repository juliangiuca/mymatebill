require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Friend do
  before(:each) do
    @valid_attributes = {
      :user_id => 1,
      :name => "friendly person"
    }
  end

  #it "should create a new instance given valid attributes" do
    #Friend.create!(@valid_attributes)
  #end

  #it "should be able to be created attached to a user" do
    #user = Factory(:user)
    #user.friends.should have(1).record
    #user.friends.create!(:name => "Trevor")
    #Friend.first.should_not be_nil
    #User.find(user.id).friends.should be_present
    #user.friends.should have(2).record
  #end

  #it "should create a hash" do
    #friend_1 = Friend.create!(:name => "albert", :user_id => 1)
    #Friend.find(friend_1.id).unique_magic_hash.should_not be_nil
  #end

  #it "should create a unique hash" do
    #loop_counter = 200
    #loop_counter.times do |t|
      #Friend.create!(:name => "albert", :user_id => t)
    #end
    #Friend.calculate(:count, :unique_magic_hash, :distinct => true).should == loop_counter
  #end

  #it "should not have leading and trailing spaces in its name" do
    #friend = Friend.create!(:name => " spacy name ", :user_id => 1)
    #friend.name.should == friend.name.strip
  #end

  describe "friends being deleted with transactions" do
    before(:each) do
      @user = Factory(:user)
      @account = Factory(:account, :user_id => @user.id)
      @friend_1 = Factory(:friend, :user_id => @user.id)
      @transaction_to_someone = Factory(:transaction, :recipient_id => @friend_1.id, :amount => "20")
      Transaction.find(@transaction_to_someone.id).line_items.should have(1).record

      @friend_2 = Factory(:friend, :user_id => @user.id)
      @transaction_from_someone = @account.transactions.new(:amount => "50")
      @transaction_from_someone.recipient_id = @user.myself_as_a_friend.id
      @transaction_from_someone.line_items.build(:amount => "50", :friend_id => @friend_2.id)
      @transaction_from_someone.save!
      Transaction.find(@transaction_from_someone.id).line_items.should have(1).record

      @user.reload
      @user.myself_as_a_friend.credit.should == 50
      @user.myself_as_a_friend.debt.should == -20
      @user.visible_friends.should have(2).records
    end

    it "should delete any transactions when a friend is deleted" do
      @user.myself_as_a_friend.transactions.should have(1).records
      #@friend_1.destroy
      #@user.reload
      #@user.myself_as_a_friend.debt.should == 0
      @friend_2.destroy
      @user.reload
      @user.myself_as_a_friend.credit.should == 0
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

