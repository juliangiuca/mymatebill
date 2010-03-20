# == Schema Information
# Schema version: 20091211225425
#
# Table name: events
#
#  id          :integer(4)      not null, primary key
#  description :string(255)
#  account_id  :integer(4)
#  due         :date
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

  it "should be able to create an event" do
    event = @account.events.create!(:description => "test event", :amount => "80", :name => "rent")
    event = Event.find(event.id)
    event.name.should == "rent"
    event.actor.name.should == "rent"
    event.amount.should == 80
  end

  it "should be able to create an event with some line items" do
    event = @account.events.new
    event.description = "Test description"
    event.amount = "123"
    event.actor_id = 1

    #line item
    line_item = event.line_items.build
    line_item.friend_id = Factory(:friend).id
    line_item.amount = "12"

    event.save!
    Event.find(event.id).line_items.should be_present
    Event.find(event.id).line_items.should have(1).record
    LineItem.last.event.should be_present
  end

  it "should create a self referencing line item" do
    event = Factory(:event)
    event.line_items.should be_present
    event.line_items.should have(1).record
    event.self_referencing_line_item.should == event.line_items.first
  end

  it "should not create a self referencing line item if other line items exist" do
    event = @account.events.new
    event.description = "Test description"
    event.amount = "123"
    event.actor_id = 1

    #line item
    friend = Factory(:friend, :name => "other name")
    friend.should_not == event.account.user.id

    line_item = event.line_items.build
    line_item.friend_id = friend.id
    line_item.amount = "12"

    event.save!
    Event.find(event.id).line_items.should be_present
    Event.find(event.id).line_items.should have(1).record
    Event.find(event.id).self_referencing_line_item.should be_blank
  end

end


