# == Schema Information
# Schema version: 20091211225425
#
# Table name: actors
#
#  id      :integer(4)      not null, primary key
#  user_id :integer(4)
#  name    :string(255)
#

class Actor < ActiveRecord::Base
  belongs_to  :user
  has_many    :events

  validates_presence_of :name
end

