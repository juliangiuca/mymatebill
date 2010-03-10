# == Schema Information
# Schema version: 20091211225425
#
# Table name: users_friends
#
#  user_id       :integer(4)
#  friend_id     :integer(4)
#  money_in      :float
#  money_out     :float
#  total         :float
#  befriended_on :date
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe UsersFriend do
  before(:each) do
    @valid_attributes = {
      
    }
  end

  it "should create a new instance given valid attributes" do
    UsersFriend.create!(@valid_attributes)
  end
end

