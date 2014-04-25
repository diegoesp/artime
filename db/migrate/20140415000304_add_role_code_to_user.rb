class AddRoleCodeToUser < ActiveRecord::Migration
  def change
    add_column :users, :role_code, :integer
    add_index :users, :role_code
  end
end
