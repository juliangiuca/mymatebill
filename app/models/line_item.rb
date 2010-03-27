# == Schema Information
# Schema version: 20091211225425
#
# Table name: line_items
#
#  id                  :integer(4)      not null, primary key
#  transaction_id      :integer(4)
#  friend_id           :integer(4)
#  amount              :float
#  due                 :date
#  paid_on             :date
#  confirmed_on        :date
#  confirmed_payment   :boolean(1)
#  state               :string(255)
#  unique_magic_hash   :string(255)
#  is_self_referencing :boolean(1)
#

class LineItem < ActiveRecord::Base
  include AASM
  belongs_to  :transaction
  belongs_to  :friend

  before_destroy :set_state_to_paid
  before_create :create_magic_hash

  validates_presence_of :amount
  validates_presence_of :friend_id
  validates_presence_of :transaction_id, :unless => Proc.new { |line_item| !line_item.transaction.nil? && line_item.transaction.new_record? }

  aasm_column :state
  aasm_initial_state :unpaid

  aasm_state :unpaid,   :enter => :create_debit,      :exit => :delete_debit
  aasm_state :pending,  :enter => :create_pending,    :exit => :delete_pending
  aasm_state :paid,     :enter => :confirm_payment, :exit => :unconfirm_payment

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

  def set_state_to_paid
    self.pay!
    self.confirm_payment!
  end

  def create_debit
    self.friend.sub_debt(self.amount)
  end

  def delete_debit
    self.friend.add_debt(self.amount)
  end

  def create_pending
    self.friend.sub_pending(self.amount)
    self.update_attribute(:paid_on, Time.now)
  end

  def delete_pending
    self.friend.add_pending(self.amount)
  end

  def confirm_payment
    self.update_attribute(:confirmed_on, Time.now)
  end

  def unconfirm_payment
    self.update_attribute(:confirmed_on, nil)
  end

  def mine?
    return true if current_user && self.friend == current_user.myself_as_a_friend
    return false
  end

  protected
  def create_magic_hash
    string_to_be_hashed = "yohgurt is sometimes gooood" + self.transaction_id.to_s + Time.now.to_f.to_s + rand().to_s
    self.unique_magic_hash = Digest::SHA1.hexdigest string_to_be_hashed
  end

end

