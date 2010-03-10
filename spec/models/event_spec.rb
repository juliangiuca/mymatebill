# == Schema Information
# Schema version: 20091211225425
#
# Table name: events
#
#  id          :integer(4)      not null, primary key
#  description :string(255)
#  account_id  :integer(4)
#  occured_on  :date
#  actor_id    :integer(4)
#  amount      :float
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Event do
  before(:each) do
    @user = Factory(:user)
    
  end

  it "should be able to create an event"
  it "should be able to create an event with an actor"

  it "should be able to create an event with some line items" do
    user = Factory(:user)
    debugger
    i=0
    i+=1

  end
end

