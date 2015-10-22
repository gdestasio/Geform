class AddStatusAndSeatsToEvents < ActiveRecord::Migration
  def change
  	add_column :events, :status, :integer, default: 0
  	add_column :events, :seats, :integer, default: 0
  end
end
