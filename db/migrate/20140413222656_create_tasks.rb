class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :name
      t.boolean :billable, default: true, null: false
      t.references :company

      t.timestamps
    end
    add_index :tasks, :company_id
    add_index :tasks, :name
  end
end
