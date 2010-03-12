# == Schema Information
# Schema version: 20091211225425
#
# Table name: friends
#
#  id            :integer(4)      not null, primary key
#  owner_id      :integer(4)
#  name          :string(255)
#  money_in      :float
#  money_out     :float
#  total         :float
#  befriended_on :date
#  hash          :string(255)
#  email_address :string(255)
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Friend do
  before(:each) do
    @valid_attributes = {
      
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
end



