class AddCoordinatesToLocationScrobbles < ActiveRecord::Migration[5.2]
  def change
    add_column :location_scrobbles, :longitude, :decimal
    add_column :location_scrobbles, :latitude, :decimal

    add_index :location_scrobbles, :longitude
    add_index :location_scrobbles, :latitude
  end
end
