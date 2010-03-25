class CreateTransactions < ActiveRecord::Migration
  def self.up
    create_table "transactions", :force => true do |t|
      t.column :description,      :string
      t.column :account_id,       :integer
      t.column :due,              :date
      t.column :actor_id,         :integer
      t.column :amount,           :float
      t.column :state,            :string, :state => "unpaid"
      t.column :recipient_id,     :integer
      t.timestamp
    end
  end

  def self.down
    drop_table "transactions"
  end
end
