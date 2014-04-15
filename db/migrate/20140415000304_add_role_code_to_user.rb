class AddRoleCodeToUser < ActiveRecord::Migration
  def change
    add_column :users, :role_code, :integer
  end
end
