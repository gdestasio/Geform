class AddOperationToTransits < ActiveRecord::Migration
  def change
  	add_column :transits, :operation, :integer
  end
end
