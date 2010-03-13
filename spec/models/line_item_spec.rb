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
#  confirmed_on      :date
#  state             :string(255)
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe LineItem do
  it "should create a new instance given valid attributes" do
    Factory(:line_item)
  end
end





