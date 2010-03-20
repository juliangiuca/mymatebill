# == Schema Information
# Schema version: 20091211225425
#
# Table name: line_items
#
#  id                :integer(4)      not null, primary key
#  event_id          :integer(4)
#  friend_id         :integer(4)
#  amount            :float
#  due               :date
#  paid_on           :date
#  confirmed_on      :date
#  confirmed_payment :boolean(1)
#  state             :string(255)
#  unique_magic_hash :string(255)
#  self_referencing  :boolean(1)
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe LineItem do
  it "should remove any self referencing line item" do
    friend = Factory(:friend, :name => "nefarious friend")
    event = Factory(:event)
    event.line_items.should have(1).record
    event.self_referencing_line_item.should be_present
    event.line_items.create!(:friend_id => friend.id, :amount => 20)
    event.reload
    event.line_items.should have(1).record
    event.self_referencing_line_item.should_not be_present
  end

  describe "should test the different method of adding a line item to an event" do
    before(:each) do
      @friend = Factory(:friend, :name => "nefarious friend")
      @event = Factory(:event)
    end

    after(:each) do
      @event.reload
      @event.line_items.should have(1).record
      @event.self_referencing_line_item.should_not be_present
    end

    it "via event.line_items << LineItem.create!" do
      Proc.new { @event.line_items << LineItem.create!(:friend_id => @friend.id, :amount => 20)}.should raise_error(ActiveRecord::RecordInvalid)
      @event.line_items << LineItem.create!(:friend_id => @friend.id, :amount => 20, :event_id => @event.id)
    end

    it "via event.line_items.build" do
      @event.line_items.build(:friend_id => @friend.id, :amount => 20)
      @event.save!
    end

    it "via event.line_items.create!" do
      @event.line_items.create!(:friend_id => @friend.id, :amount => 20)
    end
  end

  describe "testing transitions" do
    before(:each) do
      @friend = Factory(:friend)
      @line_item = Factory(:line_item, :amount => "80", :friend_id => @friend.id)
      @friend.reload
    end

    describe "when transitioning from paid to unpaid" do
      before(:each) do
        @line_item.confirm_payment!
        @friend.reload
      end

      it "should transition successfuly from paid to unpaid" do
        @line_item.unpay!
        @line_item.state.should == "unpaid"
      end

      it "should return the funds to a friend" do
        @friend.debit.should == 0
        @friend.pending.should == 0
        @line_item.unpay!
        @friend.reload
        @friend.debit.should == -80
        @friend.pending.should == 0
      end
    end

    describe "when transitioning from paid to pending" do
      before(:each) do
        @line_item.pay!
        @line_item.confirm_payment!
        @friend.reload
      end

      it "should transition successfuly from paid to pending" do
        @line_item.unpay!
        @line_item.state.should == "pending"
      end

      it "should return the funds to pending" do
        @friend.debit.should == 0
        @friend.pending.should == 0
        @line_item.unpay!
        @friend.reload
        @friend.debit.should == 0
        @friend.pending.should == -80
      end
    end

    describe "when transitioning from pending to paid" do
      before(:each) do
        @line_item.pay!
        @friend.reload
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
        @friend.reload
        @friend.debit.should == 0
        @friend.pending.should == 0
      end
    end

    describe "when transitioning from unpaid to pending" do
      #before(:each) do
      #end

      it "should transition successfuly from unpaid to pending" do
        @line_item.state.should == "unpaid"
        @line_item.pay!
        @line_item.state.should == "pending"
      end

      it "should clear the debt" do
        @friend.debit.should == -80
        @friend.pending.should == 0
        @line_item.pay!
        @friend.reload
        @friend.debit.should == 0
        @friend.pending.should == -80
      end
    end

    describe "when transitioning from unpaid to paid" do
      before(:each) do
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
        @friend.reload
        @friend.debit.should == 0
        @friend.pending.should == 0
      end
    end
  end

end



