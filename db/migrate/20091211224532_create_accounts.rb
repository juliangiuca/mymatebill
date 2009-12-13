class CreateAccounts < ActiveRecord::Migration
  def self.up
    create_table "accounts", :force => true do |t|
      t.column :name,     :string
      t.column :user_id,  :integer
    end
  end

  def self.down
    drop_table "accounts"
  end
end
