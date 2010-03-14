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
#  unique_magic_hash :string(255)
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe LineItem do
  it "should create a new instance given valid attributes" do
    Factory(:line_item)
  end

  it "should transition from unpaid to pending"
  it "should transition from unpaid to paid"
  it "should transition from pending to paid"
  it "should transition from paid to pending"

  describe "when transitioning from paid to unpaid" do
    before(:each) do
      @line_item = Factory(:line_item, :state => "paid", :amount => "80")
      @friend = @line_item.friend
    end

    it "should transition successfuly" do
      @line_item.state.should == "paid"
      @line_item.unpay!
      @line_item.state.should == "unpaid"
    end

    it "should return the funds to a friend" do
      @friend.debit.should == 0
      @line_item.unpay!
      @friend.debit.should == -80
    end
  end


end
