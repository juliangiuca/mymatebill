# == Schema Information
# Schema version: 20091211225425
#
# Table name: friends
#
#  id       :integer(4)      not null, primary key
#  owner_id :integer(4)
#  name     :string(255)
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
end


