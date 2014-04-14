class CreateInputs < ActiveRecord::Migration
  def change
    create_table :inputs do |t|
      t.references :task
      t.references :user
      t.date :input_date
      t.integer :hours

      t.timestamps
    end
    add_index :inputs, :task_id
    add_index :inputs, :user_id
  end
end
