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

  after_create :tally_friends_spending
  validates_presence_of :amount
  validates_presence_of :friend_id

  def tally_friends_spending
    self.friend.update_attribute(:money_out, self.friend.money_out - (amount || 0))
  end

end

