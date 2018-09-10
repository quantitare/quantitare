class RenameAddress1AndAddress2 < ActiveRecord::Migration[5.2]
  def change
    rename_column :places, :address1, :street_1
    rename_column :places, :address2, :street_2
  end
end
