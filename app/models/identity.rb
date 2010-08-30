
class Identity < ActiveRecord::Base
  belongs_to  :account
  has_many    :associations
  has_many    :associates, :through => :associations do
    def find_by_name_like(name)
      if [proxy_owner.name.downcase, "me", "myself", "i"].include?(name.downcase)
        return [proxy_owner]
      else
        find(:all, :conditions => ["name like ?", "#{name}%"])
      end
    end

    def find_or_create_by_name(name)
      if [proxy_owner.name.downcase, "me", "myself", "i"].include?(name.downcase)
        return proxy_owner
      else
        find(:first, :conditions => ["name = ?", name]) || create!(:name => name)
      end
    end
  end
  has_many    :transactions, :foreign_key => "owner_id"
  has_many    :incoming_transactions, :foreign_key => "to_associate_id", :class_name => "Transaction"
  has_many    :outgoing_transactions, :foreign_key => "from_associate_id", :class_name => "Step"

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

  #def future_cash_in
    #incoming_transactions.map(&:amount).sum
  #end

  #def future_cash_out
    #outgoing_transactions.map(&:amount).sum * -1
  #end

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
    incoming_transactions.each do |transaction|
      transaction.destroy
    end

    outgoing_transactions.each do |transaction|
      transaction.destroy
    end
  end

end
