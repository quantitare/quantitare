class AddGuidToPlaces < ActiveRecord::Migration[5.2]
  def change
    add_column :places, :guid, :string
  end
end
