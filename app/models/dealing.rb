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
  
  named_scope :future, lambda {{ :conditions => "due >= #{Date.today}", :order => :due }}
  named_scope :past, lambda {{ :conditions => "due < #{Date.today}", :order => :due }}
  named_scope :transactions, { :conditions => "type = 'Tranaction'" }
  named_scope :steps, { :conditions => "type = 'Step'" }

  aasm_column :state
  aasm_initial_state :unpaid

  aasm_state :unpaid, :enter => :create_debt
  aasm_state :paid,   :enter => :remove_debt

  aasm_event :pay do
    transitions :from => :unpaid, :to => :pending
  end

  aasm_event :unconfirm_payment do
    transitions :from => :pending, :to => :unpaid
  end

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


  alias available_events aasm_events_for_current_state

  PAYER_EVENTS = [:pay, :unconfirm_payment, :unpay]
  PAYEE_EVENTS = [:unconfirm_payment, :confirm_payment, :unpay]

  def payer_events
    available_events & PAYER_EVENTS
  end

  def payee_events
    available_events & PAYEE_EVENTS
  end

  def user_can_trigger_event(event, token = nil)
    event = event.to_sym

    return false unless available_events.include?(event)

    if current_user == from
      return payer_events.include?(event)
    elsif current_user == to
      return payee_events.include?(event)
    end

    return false
  end

  def user_events
    available_events.delete_if{|e| !user_can_trigger_event(e)}
  end

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
