class AddExpiresAtToPlaces < ActiveRecord::Migration[5.2]
  def change
    add_column :places, :expires_at, :datetime
  end
end
