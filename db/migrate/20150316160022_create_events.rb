class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name
      t.text :description
      t.datetime :start_at
      t.datetime :end_at
      t.string :location
      t.integer :credits, default: 0
      t.integer :min_presence_percentage, default: 80
      t.timestamps null: false
    end
  end
end
