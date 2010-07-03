class Dealing < ActiveRecord::Base
  include AASM
  belongs_to :account
  belongs_to :owner, :class_name => "Identity"
  belongs_to :to, :foreign_key => "to_associate_id", :class_name => "Identity"
  belongs_to :from, :foreign_key => "from_associate_id", :class_name => "Identity"

  validates_presence_of :amount
  validates_presence_of :due
  validates_numericality_of :amount
  validates_presence_of :to_associate_id
  validates_presence_of :from_associate_id => Proc.new {|x| x.steps.blank? }
  validates_presence_of :parent_id => Proc.new {|x| x.owner_id.blank? }

  before_validation :set_due_date

  aasm_column :state
  aasm_initial_state :unpaid

  aasm_state :unpaid
  aasm_state :pending
  aasm_state :paid,     :enter => :tally_transaction,  :exit => :revert_transaction

  aasm_event :confirm_payment do
    transitions :from => [:unpaid, :pending], :to => :paid
  end

  aasm_event :unpay do
    transitions :from => :paid, :to => :unpaid
  end

  ###### AASM methods
  def tally_transaction
  end

  def revert_transaction
  end

  ###### End AASM methods

  def set_due_date
    self[:due] ||= Date.today
  end
end
