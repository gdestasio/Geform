class AddCreditsToSubscriptions < ActiveRecord::Migration
  def change
    add_column :subscriptions, :credits, :integer, default: 0
  end
end
