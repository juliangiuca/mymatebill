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
#

class LineItem < ActiveRecord::Base
  belongs_to  :event
  belongs_to  :friend

  before_create :convert_friend_to_id

  def convert_friend_to_id
    debugger
    i=0
    i+=1
  end
end

