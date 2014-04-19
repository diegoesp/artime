class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.boolean :active
      t.date :deadline
      t.string :description
      t.references :client

      t.timestamps
    end
    
    add_index :projects, :client_id
  end
end
