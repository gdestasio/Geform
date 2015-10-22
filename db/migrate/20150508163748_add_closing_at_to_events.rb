class AddClosingAtToEvents < ActiveRecord::Migration
  def change
    add_column :events, :closing_at, :datetime
  end
end
