class RenameCountryAndAddForeigner < ActiveRecord::Migration
  def change
  	remove_column :users, :country
  	add_column :users, :country_id, :integer
  	add_column :users, :foreigner, :boolean , default: false
  end
end
