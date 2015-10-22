class CreateOptions < ActiveRecord::Migration
  def change
    create_table :options do |t|
    	t.integer :criteria_id
    	t.string :name
    	t.float :importance, default: 0
      t.timestamps null: false
    end
  end
end
