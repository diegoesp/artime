class CreateRoles < ActiveRecord::Migration
  def change
    create_table :roles do |t|
      t.integer :code
      t.references :user
      t.references :company

      t.timestamps
    end
  end
end
