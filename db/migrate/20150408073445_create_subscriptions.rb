class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
    	t.references :event
    	t.references :user
      t.timestamps null: false
    end
  end
end
