class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.references :project
      t.integer :hours_planned
      t.date :deadline

      t.timestamps
    end
    add_index :tasks, :project_id
  end
end
