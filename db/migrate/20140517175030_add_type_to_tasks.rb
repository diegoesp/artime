class AddTypeToTasks < ActiveRecord::Migration
  def change
  	add_column :tasks, :type, :string, null: false, default: "RegularTask"
    add_index :tasks, :type
  end
end