class Step < Dealing
  belongs_to :transaction, :foreign_key => "parent_id", :class_name => "Transaction"

  #validates_presence_of :parent_id

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
  def summary?
    false
  end
end
