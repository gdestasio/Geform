class CreateCertificates < ActiveRecord::Migration
  def change
    create_table :certificates do |t|
    	t.references :user, index: true, foreign_key: true, dependent: :delete
    	t.references :event, index: true, foreign_key: true, dependent: :delete
      t.timestamps null: false
    end
  end
end
