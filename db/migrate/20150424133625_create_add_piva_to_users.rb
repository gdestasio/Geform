class CreateAddPivaToUsers < ActiveRecord::Migration
  def change
    create_table :add_piva_to_users do |t|
    	add_column :users, :piva, :string
    	add_column :users, :delivery_1_address, :string
    	add_column :users, :delivery_1_zip, :string
    	add_column :users, :delivery_1_city, :integer
    	add_column :users, :delivery_1_province, :string
    	add_column :users, :delivery_1_country_id, :integer
    	add_column :users, :delivery_1_phone, :string
    	add_column :users, :delivery_1_fax, :string
      t.timestamps null: false
    end
  end
end
