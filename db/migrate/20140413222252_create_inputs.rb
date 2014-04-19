class CreateInputs < ActiveRecord::Migration
  def change
    create_table :inputs do |t|
      t.references :project_task
      t.references :user
      t.date :input_date
      t.integer :hours

      t.timestamps
    end
    add_index :inputs, :project_task_id
    add_index :inputs, :user_id
  end
end
