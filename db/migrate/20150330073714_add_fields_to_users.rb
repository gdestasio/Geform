class AddFieldsToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :taxcode, :string
  	add_column :users, :category, :integer
  	add_column :users, :sex, :string
  	add_column :users, :title, :integer
  	add_column :users, :birthdate, :date
  	add_column :users, :pec, :string
  	add_column :users, :phone, :string
  	add_column :users, :birthplace, :string
  	add_column :users, :address, :string
  	add_column :users, :city, :string
  	add_column :users, :state, :string
  	add_column :users, :zip, :string
  	add_column :users, :country, :string
  end
end
