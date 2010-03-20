# == Schema Information
# Schema version: 20091211225425
#
# Table name: accounts
#
#  id      :integer(4)      not null, primary key
#  name    :string(255)
#  user_id :integer(4)
#

class Account < ActiveRecord::Base
  has_many :events
  has_many :actors, :through => :events

  belongs_to :user

  validates_presence_of :name
  validates_uniqueness_of :name, :scope => :user_id

  before_validation :strip_blanks

  protected
  def strip_blanks
    self.name = self.name.strip
  end
end

