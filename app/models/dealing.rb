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
  before_destroy :remove_debt

  aasm_column :state
  aasm_initial_state :unpaid

  aasm_state :unpaid,   :enter => :create_debt
  aasm_state :paid,     :enter => :remove_debt

  aasm_event :confirm_payment do
    transitions :from => :unpaid, :to => :paid
  end

  aasm_event :unpay do
    transitions :from => :paid, :to => :unpaid
  end

  ###### AASM methods
  #def tally_cash
  #end

  #def revert_cash
  #end

  #def tally_pending
  #end

  def create_debt
    debugger
    i=0
    i+=1
  end

  def remove_debt
    debugger
    i=0
    i+=1
  end

  ###### End AASM methods

  def set_due_date
    self[:due] ||= Date.today
  end
end
