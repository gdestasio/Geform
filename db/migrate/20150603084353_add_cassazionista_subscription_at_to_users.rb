class AddCassazionistaSubscriptionAtToUsers < ActiveRecord::Migration
  def change
    add_column :users, :cassazionista_subscription_at, :date
  end
end
