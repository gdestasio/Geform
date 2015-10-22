class CreateEventSessions < ActiveRecord::Migration
  def change
    create_table :event_sessions do |t|
    	t.references :event, index: true, foreign_key: true, dependent: :delete
    	t.float :duration, default: 0
    	t.integer :credits, default: 0
      t.timestamps null: false
    end
  end
end
