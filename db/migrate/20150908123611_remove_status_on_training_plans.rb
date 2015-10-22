class RemoveStatusOnTrainingPlans < ActiveRecord::Migration
  def change
  	remove_column :training_plans, :status
  end
end
