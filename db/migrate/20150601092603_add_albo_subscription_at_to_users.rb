class AddAlboSubscriptionAtToUsers < ActiveRecord::Migration
  def change
    add_column :users, :albo_subscription_at, :date
  end
end
