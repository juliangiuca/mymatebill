class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table "events", :force => true do |t|
      t.column :description,      :string
      t.column :account_id,       :integer
      t.column :due,              :date
      t.column :actor_id,         :integer
      t.column :amount,           :float
      t.timestamp
    end
  end

  def self.down
    drop_table "events"
  end
end
