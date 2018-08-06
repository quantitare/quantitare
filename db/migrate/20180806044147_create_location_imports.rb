class CreateLocationImports < ActiveRecord::Migration[5.2]
  def change
    create_table :location_imports do |t|
      t.string :guid
      t.string :adapter

      t.timestamps

      t.index :guid
    end

    add_reference :location_scrobbles, :location_import, foreign_key: true
  end
end
