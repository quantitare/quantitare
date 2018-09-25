class CreatePlaceMatches < ActiveRecord::Migration[5.2]
  def change
    create_table :place_matches do |t|
      t.jsonb :source_fields, default: {}, null: false
      t.string :source_identifier

      t.references :source, polymorphic: true
      t.references :place, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps

      t.index :source_fields, using: :gin
      t.index :source_identifier
    end
  end
end
