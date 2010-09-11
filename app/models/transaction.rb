class Transaction < Dealing
  include AASM
  has_many :steps, :foreign_key => "parent_id", :class_name => "Step", :dependent => :destroy

  validates_presence_of :owner_id

  before_validation :create_steps

  accepts_nested_attributes_for :steps

  ###### AASM methods

  def create_debt
    self.steps.each {|step| step.unpay! unless step.unpaid?}
  end

  def remove_debt
    self.steps.each {|step| step.confirm_payment! unless step.paid?}
  end

  ###### End AASM methods
  def summary?
    return true
  end

  def amount
    self.steps.map(&:amount).sum
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
      unless steps.present?
        #self.steps.build(:to => self.to, :from => self.from, :amount => self[:amount])
        #self.steps.last.create_debt
        self.steps_attributes = [{:to => self.to, :from => self.from, :amount => self[:amount], :owner_id => self.owner_id}]
      end
      self.from = nil if steps.length > 1
      self[:amount] = nil
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

