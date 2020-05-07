class RenameLocationScrobblesDistanceToDistanceTraveled < ActiveRecord::Migration[6.0]
  def change
    rename_column :location_scrobbles, :distance, :distance_traveled
  end
end
