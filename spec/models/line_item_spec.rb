# == Schema Information
# Schema version: 20091211225425
#
# Table name: line_items
#
#  id                :integer(4)      not null, primary key
#  event_id          :integer(4)
#  friend_id         :integer(4)
#  amount            :float
#  paid_on           :date
#  confirmed_payment :boolean(1)
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe LineItem do
  before(:each) do
    @valid_attributes = {
      
    }
  end

  it "should create a new instance given valid attributes" do
    LineItem.create!(@valid_attributes)
  end
end

