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
    @user.accounts.length.should == 1
    @account = @user.accounts.first
  end

  it "should be able to create an event"
  it "should be able to create an event with an actor"

  it "should be able to create an event with some line items" do
    event = @account.events.new
    event.line_items.build
    event.description = "Test description"
    event.amount = "123"
    event.actor_id = 1

    #line item
    line_item = event.line_items.first
    line_item.friend_id = 1
    line_item.amount = "12"

    event.save!
    Event.first.line_items.should be_present
  end
end

