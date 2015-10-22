class CreateWaitingLists < ActiveRecord::Migration
  def change
    create_table :waiting_lists do |t|
    	t.references :user
    	t.references :event
      t.timestamps null: false
    end

    add_foreign_key :waiting_lists, :events
    add_foreign_key :waiting_lists, :users
  end
end
