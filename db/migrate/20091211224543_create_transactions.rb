class CreateTransactions < ActiveRecord::Migration
  def self.up
    create_table "transactions", :force => true do |t|
      t.column :parent_id,            :integer
      t.column :from_associate_id,    :integer
      t.column :to_associate_id,      :integer
      t.column :owner_id,             :integer
      t.column :description,          :string
      t.column :due,                  :date
      t.column :amount,               :float
      t.column :state,                :string, :state => "unpaid"
      t.column :unique_magic_hash,    :string
      t.timestamps
    end

    add_index :transactions, :unique_magic_hash
  end

  def self.down
    drop_table "transactions"
  end
end
