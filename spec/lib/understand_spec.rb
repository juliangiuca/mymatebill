require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Understand do
  before(:each) do
    @user = Factory(:account)
  end
  it "should translate the sentences" do
    sentences = [
      {
      :text => "James owes me $50",
      :creditor => @user.identity.name,
      :debitor => "James",
      :amount => "$50",
      :description => nil
    },{
      :text => "James owes me $50 for pizza",
      :creditor => @user.identity.name,
      :debitor => "James",
      :amount => "$50",
      :description => "pizza"
    },{
      :text => "I owe Henry $20",
      :creditor => "Henry",
      :debitor => @user.identity.name,
      :amount => "$20",
      :description => nil
    },{
      :text => "I owe Henry $20 for pizza",
      :creditor => "Henry",
      :debitor => @user.identity.name,
      :amount => "$20",
      :description => "pizza"
    },{
      :text => "Steve gave me $40",
      :creditor => "Steve",
      :debitor => @user.identity.name,
      :amount => "$40",
      :description => nil
    },{
      :text => "Steve lent me $40",
      :creditor => "Steve",
      :debitor => @user.identity.name,
      :amount => "$40",
      :description => nil
    }
    ]

    sentences.each do |sentence|
      translation = Understand.transaction(@user.identity, sentence[:text])

      (translation[:in_debt] || translation[:unknown_in_debt]).should == sentence[:debitor]
      (translation[:in_credit] || translation[:unknown_in_credit]).should == sentence[:creditor]
      translation[:amount].should == sentence[:amount]
      translation[:description].should == sentence[:description]

    end

  end
  it "should return an empty hash when incomplete data is parsed" do
    translation = Understand.transaction(@user, "Stever owes ")

    translation.each {|k, v| v.should be_nil}
  end
end
