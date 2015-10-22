class CreateTrainingPlans < ActiveRecord::Migration
  def change
    create_table :training_plans do |t|
      t.datetime :start_at
      t.datetime :end_at
      t.integer :status
      t.timestamps null: false
    end
  end
end
