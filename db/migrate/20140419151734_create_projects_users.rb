class CreateProjectsUsers < ActiveRecord::Migration
  def up
  	create_table :projects_users, id: false do |t|
      t.belongs_to :project
      t.belongs_to :user
    end
  end
end
