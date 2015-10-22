class CreateStates < ActiveRecord::Migration
  def change
    create_table :states do |t|
      t.string :cod_state
      t.string :name
    end
  end
end
