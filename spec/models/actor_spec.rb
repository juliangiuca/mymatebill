# == Schema Information
# Schema version: 20091211225425
#
# Table name: actors
#
#  id      :integer(4)      not null, primary key
#  user_id :integer(4)
#  name    :string(255)
#

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Actor do
  before(:each) do
    @valid_attributes = {
      :name => "Actor"
    }
  end

  it "should create a new instance given valid attributes" do
    Actor.create!(@valid_attributes)
  end
end

