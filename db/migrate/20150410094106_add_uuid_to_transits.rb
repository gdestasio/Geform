class AddUuidToTransits < ActiveRecord::Migration
  def change
  	add_column :transits, :uuid, :string
  end
end
