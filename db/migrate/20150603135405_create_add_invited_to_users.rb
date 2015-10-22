class CreateAddInvitedToUsers < ActiveRecord::Migration
  def change
    create_table :add_invited_to_users do |t|
      t.boolean :invited, default: false
      t.timestamps null: false
    end
  end
end
