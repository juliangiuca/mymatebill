# == Schema Information
# Schema version: 20091211224549
#
# Table name: transactions
#
#  id           :integer(4)      not null, primary key
#  description  :string(255)
#  account_id   :integer(4)
#  due          :date
#  actor_id     :integer(4)
#  amount       :float
#  state        :string(255)
#  recipient_id :integer(4)
#  created_at   :datetime
#  updated_at   :datetime
#

class Transaction < ActiveRecord::Base
  include AASM
  belongs_to :account
  has_many   :line_items, :before_add => :remove_self_line_item_and_add_other
  belongs_to :recipient, :class_name => "Friend"

  validates_numericality_of :amount
  validates_presence_of :amount
  validates_presence_of :recipient_id
  validates_presence_of :account_id

  validate :a_line_item_exists_if_im_the_recipient

  before_validation :strip_spaces_from_desc
  before_validation :make_sure_a_date_is_set
  before_validation :change_name_to_recipient

  before_create :create_self_representing_line_item

  attr_writer :name

  aasm_column :state
  aasm_initial_state :unpaid

  aasm_state :unpaid,   :enter => :create_credit,         :exit => :delete_credit
  aasm_state :paid,     :enter => :clear_all_line_items,  :exit => :revert_line_items

  aasm_event :confirm_payment do
    transitions :from => :unpaid, :to => :paid
  end

  aasm_event :unpay do
    transitions :from => :paid, :to => :unpaid
  end

  ###### AASM methods
  def create_credit
    self.recipient.add_credit(self.amount)
  end

  def delete_credit
    self.recipient.sub_credit(self.amount)
  end

  def clear_all_line_items
    self.line_items.each do |li|
      li.confirm_payment!
    end
  end

  def revert_line_items
    self.line_items.each do |li|
      li.unpay!
    end
  end

  ###### End AASM methods

  def change_name_to_recipient
    return unless @name
    our_recipient = self.account.user.friends.find_or_create_by_name(@name)
    self.recipient_id = our_recipient.id
  end

  def a_line_item_exists_if_im_the_recipient
    errors.add_to_base("If you're the recipient, you need to set someone to pay you!") if self.account.user.myself_as_a_friend == recipient && line_items.empty?
    return true
  end

  def recipient_name
    return nil unless @name || self.recipient
    @name || self.recipient.name
  end

  def self_referencing_line_item
    line_items.find(:first, :conditions => "is_self_referencing = true")
  end

  def mine?
    return true if current_user && self.recipient == current_user.myself_as_a_friend
    return false
  end

  protected
  def strip_spaces_from_desc
    self.description = self.description.strip
  end

  def make_sure_a_date_is_set
    self.due ||= Time.now
  end

  def create_self_representing_line_item
    return nil if self.line_items.present? || self.recipient == self.account.user.myself_as_a_friend.id
    # Build the self debt
    self.line_items.build(:friend_id => self.account.user.myself_as_a_friend.id,
                          :amount => self.amount,
                          :is_self_referencing => true)
  end

  def remove_self_line_item_and_add_other(line_item)
    line_item.transaction = self if line_item.transaction.blank?

    if self_referencing_line_item && self_referencing_line_item != line_item
      self.self_referencing_line_item.destroy
    end
  end

end

