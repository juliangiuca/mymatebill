class CreateFriends < ActiveRecord::Migration
  def self.up
    create_table "friends", :force => true do |t|
      t.column :owner_id,       :integer
    end

    create_table "users_friends", :id => false, :force => true do |t|
      t.column :user_id,        :integer
      t.column :friend_id,      :integer
      t.column :money_in,       :float
      t.column :money_out,      :float
      t.column :total,          :float
      t.column :befriended_on,  :date
      t.timestamp
    end
  end

  def self.down
    drop_table "users_friends"

    drop_table "friends"
  end
end
