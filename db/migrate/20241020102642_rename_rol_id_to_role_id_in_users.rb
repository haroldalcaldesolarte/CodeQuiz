class RenameRolIdToRoleIdInUsers < ActiveRecord::Migration[6.1]
  def change
    rename_column :users, :rol_id, :role_id
  end
end
