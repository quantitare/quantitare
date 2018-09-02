class CreateServiceCaches < ActiveRecord::Migration[5.2]
  def change
    create_table :service_caches do |t|
      t.string :type
      t.jsonb :data

      t.references :service, foreign_key: true, null: true

      t.datetime :expires_at
      t.timestamps

      t.index :type
      t.index :data, using: :gin
    end
  end
end
