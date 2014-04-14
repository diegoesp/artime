class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.boolean :active
      t.date :deadline
      t.string :description

      t.timestamps
    end
  end
end
