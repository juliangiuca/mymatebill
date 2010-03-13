# == Schema Information
# Schema version: 20091211225425
#
# Table name: friends
#
#  id                :integer(4)      not null, primary key
#  owner_id          :integer(4)
#  user_id           :integer(4)
#  name              :string(255)
#  money_in          :float           default(0.0)
#  money_out         :float           default(0.0)
#  total             :float
#  befriended_on     :date
#  unique_magic_hash :string(255)
#  email_address     :string(255)
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Friend do
  before(:each) do
    @valid_attributes = {
      :user_id => 1,
      :name => "friendly person"
    }
  end

  it "should create a new instance given valid attributes" do
    Friend.create!(@valid_attributes)
  end

  it "should be able to be created attached to a user" do
    user = Factory(:user)
    user.friends.should be_blank
    user.friends.create!(:name => "Trevor")
    Friend.first.should_not be_nil
    User.find(user).friends.should be_present
  end

  it "should create a hash" do
    friend_1 = Friend.create!(:name => "albert", :user_id => 1)
    Friend.find(friend_1.id).unique_magic_hash.should_not be_nil
  end

  it "should create a unique hash" do
    loop_counter = 200
    loop_counter.times do |t|
      Friend.create!(:name => "albert", :user_id => t)
    end
    Friend.calculate(:count, :unique_magic_hash, :distinct => true).should == loop_counter
  end

  it "should not have leading and trailing spaces in its name" do
    friend = Friend.create!(:name => " spacy name ", :user_id => 1)
    friend.name.should == friend.name.strip
  end
  
end







