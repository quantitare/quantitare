class AddIndexToPlacesGuid < ActiveRecord::Migration[5.2]
  def change
    add_index :places, :guid
  end
end
