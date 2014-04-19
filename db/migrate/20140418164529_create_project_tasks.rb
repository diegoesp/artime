class CreateProjectTasks < ActiveRecord::Migration
  def change
    create_table :project_tasks do |t|
      t.integer :hours_planned
      t.date :deadline
      t.boolean :completed, default: true, null: false
      t.boolean :billable, default: true, null: false
      t.references :task
      t.references :project

      t.timestamps
    end
    add_index :project_tasks, :task_id
    add_index :project_tasks, :project_id
  end
end
