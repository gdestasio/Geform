class ChangeForAddress < ActiveRecord::Migration
  def change
  	remove_column :users, :city
  	remove_column :users, :state

  	add_column :users, :city_id, :integer
  	add_column :users, :state_id, :integer
  	add_column :users, :province_id, :integer

  	add_foreign_key :users, :cities
  	add_foreign_key :users, :states
  	add_foreign_key :users, :provinces
  	add_foreign_key :users, :countries
  end
end
