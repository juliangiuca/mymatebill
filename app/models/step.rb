class Step < Dealing
  belongs_to :transaction, :foreign_key => "parent_id", :class_name => "Transaction"

  before_destroy :revert_transaction
  after_destroy :test_transaction_destroy

  ###### AASM methods
  def tally_transaction
    self.to.add_credit(self.amount)
    self.from.sub_debt(self.amount)
   test_transaction_paid
  end

  def revert_transaction
    if self[:state] == "paid"
      self.to.sub_credit(self.amount)
      self.from.add_debt(self.amount)
    end
   test_transaction_unpaid
  end

  ###### End AASM methods
  def summary?
    false
  end

  def test_transaction_destroy
    if Transaction.find(self.parent_id).steps.length == 0
      Transaction.find(self.parent_id).destroy
    end
  end

  def test_transaction_paid
    if self.transaction.steps.map{|x| x.paid?}.count(false) == 1
      self.transaction.update_attribute(:state, "paid")
    end
  end

  def test_transaction_unpaid
    self.transaction.update_attribute(:state, "unpaid")
  end

end
