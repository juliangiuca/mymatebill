# == Schema Information
# Schema version: 20091211225425
#
# Table name: accounts
#
#  id      :integer(4)      not null, primary key
#  name    :string(255)
#  user_id :integer(4)
#

class Account < ActiveRecord::Base
  has_many :events
  has_many :actors, :through => :events
end

