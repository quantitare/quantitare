class MoveScrobblerSchedulesToJsonb < ActiveRecord::Migration[5.2]
  def change
    remove_column :scrobblers, :schedule, :string
    add_column :scrobblers, :schedules, :jsonb, default: {}, null: false
    add_index :scrobblers, :schedules, using: 'gin'
  end
end
