class RemoveForeignerFromUsers < ActiveRecord::Migration
  def change
  	remove_column :users, :foreigner
  end
end
