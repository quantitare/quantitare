class CreateTimelineModules < ActiveRecord::Migration[6.0]
  def change
    create_table :timeline_modules do |t|
      t.string :type, index: true
      t.string :guid, index: true

      t.string :section, index: true
      t.text :options

      t.references :user

      t.timestamps
    end
  end
end
