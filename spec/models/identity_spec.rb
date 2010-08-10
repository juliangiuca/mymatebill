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

