class Change < ActiveRecord::Migration
  def change
  	remove_column :events, :location
  	add_column :events, :city, :string
  	add_column :events, :address, :string
  end
end
