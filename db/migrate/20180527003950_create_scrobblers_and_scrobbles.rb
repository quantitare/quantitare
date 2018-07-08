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

      t.references :user, foreign_key: true

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

      t.references :user, foreign_key: true
      t.references :service

      t.datetime :last_scrobbled_at
      t.timestamps

      t.index :type
      t.index :schedule
      t.index :disabled
    end

    create_table :scrobbles do |t|
      t.string :type, null: false
      t.jsonb :data
      t.string :guid, null: false

      t.references :user, foreign_key: true
      t.references :scrobbler

      t.datetime :scrobbled_at, null: false
      t.timestamps

      t.index :type
      t.index :guid
      t.index :scrobbled_at
    end
  end
end
