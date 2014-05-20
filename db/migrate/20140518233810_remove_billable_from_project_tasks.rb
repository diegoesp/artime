class RemoveBillableFromProjectTasks < ActiveRecord::Migration
  def change
  	remove_column :project_tasks, :billable
  end
end