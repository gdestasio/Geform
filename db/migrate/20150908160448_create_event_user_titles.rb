class CreateEventUserTitles < ActiveRecord::Migration
  def change
    create_table :event_user_titles do |t|
      t.references :event, index: true, foreign_key: true, dependent: :delete
      t.integer :user_title      
    end
  end
end
