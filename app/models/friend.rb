
class Friend < ActiveRecord::Base
  belongs_to  :creator, :class_name => "User", :foreign_key => "user_id"
  has_one     :owner, :class_name => "User", :foreign_key => "id"
  has_many    :line_items
  has_many    :transactions, :foreign_key => "recipient_id", :dependent => :destroy

  before_create :create_magic_hash
  before_create :set_befriended_on

  before_destroy :reset_debts

  validates_presence_of :user_id
  validates_presence_of :name

  before_validation :strip_blanks
  validates_uniqueness_of :name, :scope => :user_id

  def name
    return self['name'].capitalize
  end

  def sub_credit(amount)
    self.update_attribute(:credit, self.credit - amount)
  end

  def add_credit(amount)
    self.update_attribute(:credit, self.credit + amount)
  end
  def sub_debt(amount)
    self.update_attribute(:debt, self.debt - amount)
  end

  def add_debt(amount)
    self.update_attribute(:debt, self.debt + amount)
  end

  def sub_pending(amount)
    self.update_attribute(:pending, self.pending - amount)
  end

  def add_pending(amount)
    self.update_attribute(:pending, self.pending + amount)
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
    
    line_items.each do |line_item|
      if line_item.transaction.line_items.length == 1
        line_item.transaction.destroy
      else
        line_item.destroy
      end
    end

  end

end





# == Schema Information
#
# Table name: friends
#
#  id                :integer(4)      not null, primary key
#  owner_id          :integer(4)
#  user_id           :integer(4)
#  name              :string(255)
#  credit            :float           default(0.0)
#  debt              :float           default(0.0)
#  pending           :float           default(0.0)
#  total             :float
#  befriended_on     :date
#  unique_magic_hash :string(255)
#  email_address     :string(255)
#  hidden            :boolean(1)      default(FALSE)
#

