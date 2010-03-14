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
#  unique_magic_hash :string(255)
#

class LineItem < ActiveRecord::Base
  include AASM 
  belongs_to  :event
  belongs_to  :friend

  #after_create :tally_friends_spending
  before_destroy :set_state_to_paid
  before_create :create_magic_hash

  validates_presence_of :amount
  validates_presence_of :friend_id

  aasm_column :state
  aasm_initial_state :unpaid

  aasm_state :unpaid, :enter => :create_debit, :exit => :delete_debit
  aasm_state :pending, :enter => :create_pending, :exit => :delete_pending
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

  #def tally_friends_spending
    #self.friend.update_attribute(:debit, self.friend.debit - (self.amount || 0))
  #end

  def set_state_to_paid
    self.pay!
    self.confirm_payment!
  end

  def create_debit
    self.friend.sub_debit(self.amount)
  end

  def delete_debit
    self.friend.add_debit(self.amount)
  end

  def create_pending
    self.friend.sub_pending(self.amount)
  end

  def delete_pending
    self.friend.add_pending(self.amount)
  end


  protected
  def create_magic_hash
    string_to_be_hashed = "yohgurt is sometimes gooood" + self.event.actor.name + Time.now.to_f.to_s + rand().to_s

    self.unique_magic_hash = Digest::SHA1.hexdigest string_to_be_hashed
  end
end
