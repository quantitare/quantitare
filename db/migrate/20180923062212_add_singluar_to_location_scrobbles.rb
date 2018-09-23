class AddSingluarToLocationScrobbles < ActiveRecord::Migration[5.2]
  def change
    add_column :location_scrobbles, :singular, :boolean, default: false, null: false
  end
end
