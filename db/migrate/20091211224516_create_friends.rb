class CreateFriends < ActiveRecord::Migration
  def self.up
    create_table "friends", :force => true do |t|
      t.column :owner_id,       :integer
      t.column :name,           :string
      t.column :money_in,       :float
      t.column :money_out,      :float
      t.column :total,          :float
      t.column :befriended_on,  :date
      t.column :hash,           :string
      t.column :email_address,  :string
      t.timestamp
    end

    add_index :friends, :hash
  end

  def self.down
    drop_table "friends"
  end
end
