class CreateCities < ActiveRecord::Migration
  def change
    create_table :cities do |t|
      t.string :cod_state
      t.string :cod_province
      t.string :cod_city
      t.string :cod_istat
      t.string :name
      t.string :belfiore
    end
  end
end
