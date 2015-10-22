class AddProponentAndValidatorToEvents < ActiveRecord::Migration
  def change
  	add_column :events, :proponent_id, :integer
  	add_column :events, :validator_id, :integer
  end
end
