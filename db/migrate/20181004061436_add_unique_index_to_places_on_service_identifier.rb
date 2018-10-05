class AddUniqueIndexToPlacesOnServiceIdentifier < ActiveRecord::Migration[5.2]
  def change
    add_index :places, [:service_id, :service_identifier], unique: true
  end
end
