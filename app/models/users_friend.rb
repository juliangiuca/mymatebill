# == Schema Information
# Schema version: 20091211225425
#
# Table name: users_friends
#
#  user_id       :integer(4)
#  friend_id     :integer(4)
#  money_in      :float
#  money_out     :float
#  total         :float
#  befriended_on :date
#

class UsersFriend < ActiveRecord::Base

  belongs_to :user
  belongs_to :friend
  belongs_to :owner, :class_name => "Friend"
end

