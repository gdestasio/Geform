class CreateProvinces < ActiveRecord::Migration
  def change
    create_table :provinces do |t|
      t.string :cod_state
      t.string :cod_province
      t.string :name
      t.string :initials
    end
  end
end
