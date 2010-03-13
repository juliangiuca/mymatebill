class CreateFriends < ActiveRecord::Migration
  def self.up
    create_table "friends", :force => true do |t|
      t.column :owner_id,                     :integer
      t.column :user_id,                      :integer
      t.column :name,                         :string
      t.column :money_in,                     :float, :default => 0
      t.column :money_out,                    :float, :default => 0
      t.column :total,                        :float
      t.column :befriended_on,                :date
      t.column :unique_magic_hash,            :string
      t.column :email_address,                :string
      t.timestamp
    end

    add_index :friends, :unique_magic_hash
    add_index :friends, :user_id
  end

  def self.down
    drop_table "friends"
  end
end
