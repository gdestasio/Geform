class AddTokenToEvents < ActiveRecord::Migration
  def change
  	add_column :events, :token, :string, unique: true
  end
end
