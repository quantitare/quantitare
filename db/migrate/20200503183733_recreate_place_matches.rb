class RecreatePlaceMatches < ActiveRecord::Migration[6.0]
  def change
    drop_table :place_matches

    create_table(:place_matches) do |t|
      t.string :source_field_name, index: true
      t.decimal :source_field_radius, index: true
      t.decimal :source_field_longitude, index: true
      t.decimal :source_field_latitude, index: true

      t.string :source_identifier, index: true
      t.references :source, polymorphic: true, index: true
      t.references :place, index: true
      t.references :user, index: true

      t.timestamps
    end
  end
end
