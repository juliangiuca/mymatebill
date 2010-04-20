# == Schema Information
# Schema version: 20091211224549
#
# Table name: transactions
#
#  id                :integer(4)      not null, primary key
#  description       :string(255)
#  account_id        :integer(4)
#  due               :date
#  actor_id          :integer(4)
#  amount            :float
#  state             :string(255)
#  recipient_id      :integer(4)
#  unique_magic_hash :string(255)
#  created_at        :datetime
#  updated_at        :datetime
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Transaction do
  before(:each) do
    @user = Factory(:user)
    @user.accounts.length.should == 1
    @account = @user.accounts.first
    @frog = @user.friends.create!(:name => "Frog")
  end

  it "should be able to create an transaction" do
    transaction = @account.transactions.create!(:description => "test transaction", :amount => "80", :name => "rent")
    transaction = Transaction.find(transaction.id)
    transaction.respond_to?(:name).should be_false
    transaction.recipient.name.should == "Rent"
    transaction.amount.should == 80
  end

  it "should be able to create an transaction with some line items" do
    transaction = @account.transactions.new
    transaction.description = "Test description"
    transaction.amount = "123"
    transaction.recipient_id = @frog.id

    #line item
    line_item = transaction.line_items.build
    line_item.friend_id = Factory(:friend).id
    line_item.amount = "12"

    transaction.save!
    Transaction.find(transaction.id).line_items.should be_present
    Transaction.find(transaction.id).line_items.should have(1).record
    LineItem.last.transaction.should be_present
  end

  it "should create a self referencing line item" do
    transaction = Factory(:transaction)
    transaction.line_items.should be_present
    transaction.line_items.should have(1).record
    transaction.self_referencing_line_item.should == transaction.line_items.first
  end

  it "should not create a self referencing line item if other line items exist" do
    transaction = @account.transactions.new
    transaction.description = "Test description"
    transaction.amount = "123"
    transaction.recipient_id = @frog.id

    #line item
    friend = Factory(:friend, :name => "other name")
    friend.should_not == transaction.account.user.id

    line_item = transaction.line_items.build
    line_item.friend_id = friend.id
    line_item.amount = "12"

    transaction.save!
    Transaction.find(transaction.id).line_items.should be_present
    Transaction.find(transaction.id).line_items.should have(1).record
    Transaction.find(transaction.id).self_referencing_line_item.should be_blank
  end

  describe "for non formal transactions between friends" do

    it "Frog owes me $20" do
      transaction = @account.transactions.new(:description => "Frog owes me $20",
                              :amount => 20,
                              :name => "Me")
      transaction.line_items.build(:amount => 20,
                               :friend_id => @frog.id)
      transaction.save!

      @user.myself_as_a_friend.credit.should == 20
      @frog.reload
      @frog.debt.should == -20
    end

     it "I owe Frog $20" do
      @account.transactions.create!(:description => "I owe Frog $20",
                              :amount => 20,
                              :name => "Frog")
      @user.myself_as_a_friend.debt.should == -20
      @frog.reload
      @frog.credit.should == 20

    end
  end

end





