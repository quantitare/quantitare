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

      t.references :service, foreign_key: true
      t.references :user, foreign_key: true

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

      t.references :place, foreign_key: true
      t.references :user, foreign_key: true

      t.datetime :start_time, null: false
      t.datetime :end_time, null: false
      t.timestamps

      t.index [:type, :category]
      t.index :trackpoints, using: :gin
    end
  end
end
