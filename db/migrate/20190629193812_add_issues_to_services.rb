class AddIssuesToServices < ActiveRecord::Migration[5.2]
  def change
    add_column :services, :issues, :jsonb, default: []
    add_index :services, :issues, using: :gin
  end
end
