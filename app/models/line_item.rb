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
#

class LineItem < ActiveRecord::Base
  include AASM 
  belongs_to  :event
  belongs_to  :friend

  after_create :tally_friends_spending
  validates_presence_of :amount
  validates_presence_of :friend_id

  aasm_column :state
  aasm_initial_state :unpaid

  aasm_state :unpaid
  aasm_state :pending
  aasm_state :paid

  aasm_event :pay do
    transitions :from => :unpaid, :to => :pending
  end

  aasm_event :confirm_payment do
    transitions :from => [:unpaid, :pending], :to => :paid
  end

  aasm_event :unpay do
    transitions :from => :pending, :to => :unpaid
    transitions :from => :paid, :to => :pending, :guard => Proc.new {|li| !li.paid_on.blank?}
    transitions :from => :paid, :to => :unpaid
  end

  def tally_friends_spending
    self.friend.update_attribute(:money_out, self.friend.money_out - (amount || 0))
  end

end





