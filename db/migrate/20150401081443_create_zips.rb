class CreateZips < ActiveRecord::Migration
  def change
    create_table :zips do |t|
      t.string :cod_istat
      t.string :city
      t.string :prefix
      t.string :zip
    end
  end
end
