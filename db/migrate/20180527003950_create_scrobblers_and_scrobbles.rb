# frozen_string_literal: true

class CreateScrobblersAndScrobbles < ActiveRecord::Migration[5.2]
  def change
    create_table :services do |t|
      t.string :provider, null: false
      t.string :name, null: false
      t.text :token, null: false
      t.text :secret
      t.string :uid
      t.text :refresh_token

      t.jsonb :options, default: {}

      t.references :user, foreign_key: true, null: false

      t.datetime :expires_at
      t.timestamps

      t.index :provider
      t.index :uid
    end

    create_table :scrobblers do |t|
      t.text :options
      t.string :type, null: false
      t.string :name
      t.string :schedule
      t.string :guid, null: false

      t.boolean :disabled, default: false, null: false

      t.references :user, foreign_key: true, null: false
      t.references :service, foreign_key: true, null: true

      t.integer :scrobbles_count

      t.datetime :last_scrobbled_at
      t.timestamps

      t.index :type
      t.index :guid
      t.index :schedule
      t.index :disabled
    end

    create_table :scrobbles do |t|
      t.string :type, null: false
      t.string :category, null: false
      t.jsonb :data, null: false, default: {}

      t.string :guid, null: false

      t.references :user, foreign_key: true, null: false
      t.references :source, polymorphic: true, null: false

      t.datetime :start_time, null: false
      t.datetime :end_time, null: false
      t.tsrange :period
      t.timestamps

      t.index :type
      t.index :category
      t.index :data, using: :gin

      t.index :guid

      t.index :start_time
      t.index :end_time
      t.index :period, using: :gist
    end
  end
end
