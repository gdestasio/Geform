class AddRoleToAdmins < ActiveRecord::Migration
  def change
  	add_column :admins,:role,:integer
  end
end
