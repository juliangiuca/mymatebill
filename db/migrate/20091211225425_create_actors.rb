class CreateActors < ActiveRecord::Migration
  def self.up
    create_table "actors", :force => true do |t|
      t.column :user_id,    :integer
      t.column :name,       :string
      t.timestamp
    end
  end

  def self.down
    drop_table "actors"
  end
end
