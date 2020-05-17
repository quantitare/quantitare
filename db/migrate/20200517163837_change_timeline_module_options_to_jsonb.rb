class ChangeTimelineModuleOptionsToJsonb < ActiveRecord::Migration[6.0]
  def change
    remove_column :timeline_modules, :options, :text

    add_column :timeline_modules, :options, :jsonb
    add_index :timeline_modules, :options, using: :gin
  end
end
