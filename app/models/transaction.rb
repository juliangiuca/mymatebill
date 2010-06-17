class Transaction < ActiveRecord::Base
  include AASM
  belongs_to :account
  belongs_to :owner, :class_name => "Identity"
  belongs_to :to, :foreign_key => "to_associate_id", :class_name => "Identity"
  belongs_to :from, :foreign_key => "from_associate_id", :class_name => "Identity"
  has_many :steps, :foreign_key => "parent_id", :class_name => "Transaction"
  belongs_to :summary, :foreign_key => "parent_id", :class_name => "Transaction"

  validates_presence_of :amount
  validates_numericality_of :amount
  validates_presence_of :to_associate_id => Proc.new {|x| x.parent_id.blank? }
  validates_presence_of :from_associate_id => Proc.new {|x| x.steps.blank? }
  validates_presence_of :owner_id => Proc.new {|x| x.parent_id.blank? }
  validates_presence_of :parent_id => Proc.new {|x| x.owner_id.blank? }

  #validate :a_line_item_exists_if_im_the_recipient

  #before_validation :strip_spaces_from_desc
  #before_validation :make_sure_a_date_is_set

  before_save :create_steps
  before_destroy :remove_steps
  #before_create :adjust_summary_total_parent
  #after_create :adjust_summary_total_step

  aasm_column :state
  aasm_initial_state :unpaid

  aasm_state :unpaid
  aasm_state :pending
  aasm_state :paid,     :enter => :tally_transaction,  :exit => :revert_transaction

  aasm_event :confirm_payment do
    transitions :from => :unpaid, :to => :paid
  end

  aasm_event :unpay do
    transitions :from => :paid, :to => :unpaid
  end

  ###### AASM methods
  def tally_transaction
    self.to.add_credit(self.amount)
    self.from.sub_debt(self.amount)
  end

  def revert_transaction
    self.to.sub_credit(self.amount)
    self.from.add_debt(self.amount)
  end

  ###### End AASM methods

  #def a_line_item_exists_if_im_the_recipient
    #errors.add_to_base("If you're the recipient, you need to set someone to pay you!") if self.account.user.myself_as_a_friend == recipient && line_items.empty?
    #return true
  #end

  def adjust_total
  end

  #def self_referencing_line_item
    #line_items.find(:first, :conditions => "is_self_referencing = true")
  #end

  #def mine?
    #return true if current_user && self.recipient == current_user.myself_as_a_friend
    #return false
  #end

  def summary?
    return true if self.summary.blank?
  end

  def amount
    if self.steps.present?
      self.steps.map(&:amount).sum
    else
      self[:amount]
    end
  end

  protected
  def strip_spaces_from_desc
    self.description = self.description.strip if self.description
  end

  def make_sure_a_date_is_set
    self.due ||= 1.week.since
  end

  def create_magic_hash
    string_to_be_hashed = "yohgurt is sometimes goood" + self.amount.to_s + Time.now.to_f.to_s + rand().to_s
    self.unique_magic_hash = Digest::SHA1.hexdigest string_to_be_hashed
  end

  def set_state_to_paid
    self.confirm_payment!
  end

  def create_steps
    debugger
    if self.summary?
      self.steps.build(:to => self.to, :from => self.from, :amount => self.amount)
      self.from = nil if steps.length > 1
      self.amount = nil
    end
  end

  def remove_steps
    if self.summary.present? && self.summary.steps.length == 2
      self.summary.from = (self.summary.steps - self)
    end
  end

  def adjust_summary_total_parent
    if self.summary.blank?
      total = self.steps.map(&:amount).sum
      self.amount = total
    end
  end

  def adjust_summary_total_step
    if self.summary.present?
      total = self.steps.map(&:amount).sum
      Transaction.find(self.summary.id).update_attribute(:amount, total)
    end
  end

end

