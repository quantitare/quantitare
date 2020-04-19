class AddRankToTimelineModules < ActiveRecord::Migration[6.0]
  def change
    add_column :timeline_modules, :rank, :integer
  end
end
