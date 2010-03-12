# == Schema Information
# Schema version: 20091211225425
#
# Table name: friends
#
#  id            :integer(4)      not null, primary key
#  owner_id      :integer(4)
#  name          :string(255)
#  money_in      :float
#  money_out     :float
#  total         :float
#  befriended_on :date
#  hash          :string(255)
#  email_address :string(255)
#

class Friend < ActiveRecord::Base
  belongs_to  :user
  has_many    :line_items
end



