class AddIndexToSubscriptions < ActiveRecord::Migration
  def change
  	add_index :subscriptions, [:event_id, :user_id], unique: true
  end
end
