# == Schema Information
# Schema version: 20091211225425
#
# Table name: events
#
#  id          :integer(4)      not null, primary key
#  description :string(255)
#  account_id  :integer(4)
#  occured_on  :date
#  actor_id    :integer(4)
#  amount      :float
#

class Event < ActiveRecord::Base
  belongs_to :account
  belongs_to :actor
  has_many   :line_items

  validates_presence_of :actor_id, :message => "can't be blank"
  validates_numericality_of :amount

  before_validation :strip_spaces
  before_validation :make_sure_a_date_is_set

  HUMANIZED_ATTRIBUTES = {
    :actor_id => "Event name"
  }

  def self.human_attribute_name(attr)
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end

  protected
  def strip_spaces
    self.description = self.description.strip
  end

  def make_sure_a_date_is_set
    self.occured_on ||= Time.now
  end
end

