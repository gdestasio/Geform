class AddDescToTrainingPlan < ActiveRecord::Migration
  def change
  	add_column :training_plans, :description, :text
  end
end
