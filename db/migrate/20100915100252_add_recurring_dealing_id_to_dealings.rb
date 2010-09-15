class AddRecurringDealingIdToDealings < ActiveRecord::Migration
  def self.up
    add_column :dealings, :recurring_dealing_id, :integer
  end

  def self.down
    remove_column :dealings, :recurring_dealing_id
  end
end
