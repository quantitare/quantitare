class CreateLocationImports < ActiveRecord::Migration[5.2]
  def change
    create_table :location_imports do |t|
      t.string :guid
      t.string :adapter

      t.references :user, foreign_key: true, null: false

      t.timestamps

      t.index :guid
    end
  end
end
