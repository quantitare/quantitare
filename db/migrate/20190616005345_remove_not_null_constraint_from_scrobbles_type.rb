class RemoveNotNullConstraintFromScrobblesType < ActiveRecord::Migration[5.2]
  def change
    change_column :scrobbles, :type, :string, null: true
  end
end
