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

class Event < ActiveRecord::Base
  belongs_to :account
  belongs_to :actor

  validates_presence_of :actor_id
end

