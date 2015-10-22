class CreateSpeakers < ActiveRecord::Migration
  def change
    create_table :speakers do |t|
      t.references :event, index: true, foreign_key: true, dependent: :delete
    	t.string :name
      t.timestamps null: false
    end
  end
end
