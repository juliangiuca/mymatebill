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


  describe "when transitioning from paid to unpaid" do
    before(:each) do
      @line_item = Factory(:line_item, :amount => "80")
      @friend = @line_item.friend
      @line_item.confirm_payment!
    end

    it "should transition successfuly from paid to unpaid" do
      @line_item.unpay!
      @line_item.state.should == "unpaid"
    end

    it "should return the funds to a friend" do
      @friend.debit.should == 0
      @friend.pending.should == 0
      @line_item.unpay!
      @friend.debit.should == -80
      @friend.pending.should == 0
    end
  end

  describe "when transitioning from paid to pending" do
    before(:each) do
      @line_item = Factory(:line_item, :amount => "80")
      @friend = @line_item.friend
      @line_item.pay!
      @line_item.confirm_payment!
    end

    it "should transition successfuly from paid to pending" do
      @line_item.unpay!
      @line_item.state.should == "pending"
    end

    it "should return the funds to pending" do
      @friend.debit.should == 0
      @friend.pending.should == 0
      @line_item.unpay!
      @friend.debit.should == 0
      @friend.pending.should == -80
    end
  end

  describe "when transitioning from pending to paid" do
    before(:each) do
      @line_item = Factory(:line_item, :amount => "80")
      @friend = @line_item.friend
      @line_item.pay!
    end

    it "should transition successfuly from pending to paid" do
      @line_item.state.should == "pending"
      @line_item.confirm_payment!
      @line_item.state.should == "paid"
    end

    it "should clear the debt" do
      @friend.debit.should == 0
      @friend.pending.should == -80
      @line_item.confirm_payment!
      @friend.debit.should == 0
      @friend.pending.should == 0
    end
  end

  describe "when transitioning from unpaid to pending" do
    before(:each) do
      @line_item = Factory(:line_item, :amount => "80")
      @friend = @line_item.friend
    end

    it "should transition successfuly from pending to paid" do
      @line_item.state.should == "unpaid"
      @line_item.pay!
      @line_item.state.should == "pending"
    end

    it "should clear the debt" do
      @friend.debit.should == -80
      @friend.pending.should == 0
      @line_item.pay!
      @friend.debit.should == 0
      @friend.pending.should == -80
    end
  end

  describe "when transitioning from unpaid to paid" do
    before(:each) do
      @line_item = Factory(:line_item, :amount => "80")
      @friend = @line_item.friend
    end

    it "should transition successfuly from unpaid to paid" do
      @line_item.state.should == "unpaid"
      @line_item.confirm_payment!
      @line_item.state.should == "paid"
    end

    it "should clear the debt" do
      @friend.debit.should == -80
      @friend.pending.should == 0
      @line_item.confirm_payment!
      @friend.debit.should == 0
      @friend.pending.should == 0
    end
  end

end
