# == Schema Information
# Schema version: 20091211225425
#
# Table name: accounts
#
#  id      :integer(4)      not null, primary key
#  name    :string(255)
#  user_id :integer(4)
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Account do
  before(:each) do
  end

  it "should create a new instance given valid attributes" do
    Factory(:account)
  end

  it "should not allow leading / trailing spaces in the name" do
    account = Factory(:account, :name => " spacy name ")
    account.name.should == account.name.strip
  end

end

