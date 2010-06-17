class CreateIdentities < ActiveRecord::Migration
  def self.up
    create_table "identities", :force => true do |t|
      t.column :account_id,                   :integer
      t.column :name,                         :string
      t.column :cash_in,                      :float, :default => 0
      t.column :cash_out,                     :float, :default => 0
      t.column :cash_pending,                 :float, :default => 0
      t.column :total,                        :float, :total => 0
      t.column :befriended_on,                :date
      t.column :unique_magic_hash,            :string
      t.column :email,                        :string
      t.column :deleted_at,                   :datetime, :default => nil
      t.timestamp
    end

    add_index :identities, :unique_magic_hash
    add_index :identities, :account_id

    create_table "associations", :id => false, :force => true do |t|
      t.column :identity_id,    :integer
      t.column :associate_id,   :integer
      t.column :nickname,       :string
      t.column :deleted_at,     :datetime, :default => nil
    end
  end

  def self.down
    drop_table "associations"

    remove_index :identities, :column => :account_id
    remove_index :identities, :column => :unique_magic_hash

    drop_table "identities"
  end
end
