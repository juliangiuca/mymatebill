class CreateLineItems < ActiveRecord::Migration
  def self.up
    create_table "line_items", :force => true do |t|
      t.column :event_id,           :integer
      t.column :friend_id,          :integer
      t.column :amount,             :float
      t.column :due,                :date
      t.column :paid_on,            :date
      t.column :confirmed_on,       :date
      t.column :confirmed_payment,  :boolean
      t.column :state,              :string, :state => "unpaid"
      t.column :unique_magic_hash,  :string
      t.column :self_referencing,   :boolean, :default => false
      t.timestamp
    end
  end

  def self.down
    drop_table "line_items"
  end
end
