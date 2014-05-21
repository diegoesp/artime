class AddInternalToProjects < ActiveRecord::Migration
  def change
  	add_column :projects, :internal, :boolean, null: false, default: false
  end
end