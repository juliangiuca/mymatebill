class CreateLineItems < ActiveRecord::Migration
  def self.up
    create_table "line_items", :force => true do |t|
      t.column :event_id,           :integer
      t.column :friend_id,          :integer
      t.column :amount,             :float
      t.column :paid_on,            :date
      t.column :confirmed_payment,  :boolean
    end
  end

  def self.down
    drop_table "line_items"
  end
end
