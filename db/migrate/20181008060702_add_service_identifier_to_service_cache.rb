class AddServiceIdentifierToServiceCache < ActiveRecord::Migration[5.2]
  def change
    add_column :service_caches, :service_identifier, :string
    add_index :service_caches, [:service_id, :service_identifier], unique: true
  end
end
