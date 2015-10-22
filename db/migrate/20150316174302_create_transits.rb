class CreateTransits < ActiveRecord::Migration
  def change
    create_table :transits do |t|
      t.references :event
      t.references :user
      t.datetime :transited_at
      t.timestamps null: false
    end

    add_foreign_key :transits, :events
    add_foreign_key :transits, :users
  end
end
