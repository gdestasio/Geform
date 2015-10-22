class AddMoreFieldsToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :graduated_at, :date
  end
end
