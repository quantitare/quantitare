class AddEarliestDataAtToScrobblers < ActiveRecord::Migration[5.2]
  def change
    add_column :scrobblers, :earliest_data_at, :timestamp
  end
end
