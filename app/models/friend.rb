# == Schema Information
# Schema version: 20091211225425
#
# Table name: friends
#
#  id                :integer(4)      not null, primary key
#  owner_id          :integer(4)
#  user_id           :integer(4)
#  name              :string(255)
#  money_in          :float           default(0.0)
#  money_out         :float           default(0.0)
#  total             :float
#  befriended_on     :date
#  unique_magic_hash :string(255)
#  email_address     :string(255)
#

class Friend < ActiveRecord::Base
  belongs_to  :user
  has_many    :line_items

  before_create :create_magic_hash

  validates_presence_of :user_id
  validates_presence_of :name

  before_validation :strip_blanks
  validates_uniqueness_of :name, :scope => :user_id

  def create_magic_hash
    string_to_be_hashed = "cheese is gooood" + name + Time.now.to_f.to_s + rand().to_s

    self.unique_magic_hash = Digest::SHA1.hexdigest string_to_be_hashed
  end

  protected
  def strip_blanks
    self.name = self.name.strip
  end

end







