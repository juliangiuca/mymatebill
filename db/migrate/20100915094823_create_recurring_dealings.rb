class CreateRecurringDealings < ActiveRecord::Migration
  def self.up
    create_table :recurring_dealings do |t|
      t.integer :parent_id
      t.integer :from_associate_id
      t.integer :to_associate_id
      t.integer :owner_id
      t.string :description
      t.float :amount
      t.string :rec_type
      t.string :type
      t.date :start_date
      t.date :end_date

      t.timestamps
    end
  end

  def self.down
    drop_table :recurring_dealings
  end
end
