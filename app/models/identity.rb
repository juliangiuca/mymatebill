
class Identity < ActiveRecord::Base
  belongs_to  :account
  has_many    :associations
  has_many    :associates, :through => :associations, :foreign_key => "crap"
  has_many    :transactions, :foreign_key => "owner_id"
  #has_many :transactions
  has_many    :incoming_transactions, :foreign_key => "to_associate", :class_name => "Transaction"
  has_many    :outgoing_transactions, :foreign_key => "from_associate", :class_name => "Transaction"

  before_create :create_magic_hash
  before_create :set_befriended_on

  before_destroy :reset_debts

  validates_presence_of :name

  before_validation :strip_blanks
  validates_uniqueness_of :name, :scope => :account_id

  def name
    return self['name'].capitalize
  end

  def sub_credit(amount)
    self.update_attribute(:cash_in, self.cash_in - amount)
  end

  def add_credit(amount)
    self.update_attribute(:cash_in, self.cash_in + amount)
  end
  def sub_debt(amount)
    self.update_attribute(:cash_out, self.cash_out - amount)
  end

  def add_debt(amount)
    self.update_attribute(:cash_out, self.cash_out + amount)
  end

  def sub_pending(amount)
    self.update_attribute(:cash_pending, self.cash_pending - amount)
  end

  def add_pending(amount)
    self.update_attribute(:cash_pending, self.cash_pending + amount)
  end

  protected
  def strip_blanks
    self.name = self.name.strip
  end

  def create_magic_hash
    string_to_be_hashed = "cheese is gooood" + name + Time.now.to_f.to_s + rand().to_s

    self.unique_magic_hash = Digest::SHA1.hexdigest string_to_be_hashed
  end

  def set_befriended_on
    self.befriended_on = Time.now
  end

  def reset_debts
    #transactions.each do |transaction|
      #transaction.destroy
    #end
    
    #line_items.each do |line_item|
      #if line_item.transaction.line_items.length == 1
        #line_item.transaction.destroy
      #else
        #line_item.destroy
      #end
    #end

  end

end
