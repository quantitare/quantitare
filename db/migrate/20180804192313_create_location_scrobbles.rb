class CreateLocationScrobbles < ActiveRecord::Migration[5.2]
  def change
    create_table :places do |t|
      t.string :name, null: false

      t.string :address1
      t.string :address2
      t.string :city
      t.string :state
      t.string :zip
      t.string :country

      t.decimal :latitude
      t.decimal :longitude

      t.string :category
      t.text :description

      t.string :service_identifier
      t.boolean :global

      t.references :user, foreign_key: true, null: false
      t.references :service, foreign_key: true, null: true

      t.timestamps

      t.index :name
      t.index :category
      t.index :service_identifier
    end

    create_table :location_scrobbles do |t|
      t.string :type, null: false
      t.string :name
      t.string :category
      t.decimal :distance
      t.text :description

      t.jsonb :trackpoints, null: false, default: '[]'

      t.references :user, foreign_key: true, null: false
      t.references :place, foreign_key: true, null: true
      t.references :source, polymorphic: true, null: false

      t.datetime :start_time, null: false
      t.datetime :end_time, null: false
      t.tsrange :period
      t.timestamps

      t.index [:type, :category]
      t.index :trackpoints, using: :gin
      t.index :start_time
      t.index :end_time
      t.index :period, using: :gist
    end
  end
end
