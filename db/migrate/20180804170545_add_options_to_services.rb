class AddOptionsToServices < ActiveRecord::Migration[5.2]
  def change
    add_column :services, :options, :jsonb
  end
end
