# == Schema Information
# Schema version: 20091211225425
#
# Table name: transactions
#
#  id          :integer(4)      not null, primary key
#  description :string(255)
#  account_id  :integer(4)
#  due         :date
#  actor_id    :integer(4)
#  amount      :float
#

class Transaction < ActiveRecord::Base
  belongs_to :account
  belongs_to :actor
  has_many   :line_items, :before_add => :remove_self_line_item_and_add_other

  validates_presence_of :actor_id, :message => "can't be blank"
  validates_numericality_of :amount

  before_validation :strip_spaces
  before_validation :make_sure_a_date_is_set
  before_validation :change_name_to_actor

  before_create :create_self_representing_line_item

  attr_writer :name

  #HUMANIZED_ATTRIBUTES = {
    #:actor_id => "Event name"
  #}

  #def self.human_attribute_name
    #HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  #end

  def change_name_to_actor
    return unless @name
    actor = self.account.user.actors.find_or_create_by_name(@name)
    self.actor_id = actor.id
  end

  def name
    return nil unless @name || self.actor
    @name || self.actor.name
  end

  def self_referencing_line_item
    line_items.find(:first, :conditions => "self_referencing = true")
  end

  protected
  def strip_spaces
    self.description = self.description.strip
  end

  def make_sure_a_date_is_set
    self.due ||= Time.now
  end

  def create_self_representing_line_item
    return nil if self.line_items.present?
    self.line_items.build(:friend_id => self.account.user.myself_as_a_friend.id, 
                            :amount => self.amount,
                            :self_referencing => true)
  end

  def remove_self_line_item_and_add_other(line_item)
    line_item.transaction = self if line_item.transaction.blank?

    if self_referencing_line_item && self_referencing_line_item != line_item
      self.self_referencing_line_item.destroy
    end
  end
  
end



