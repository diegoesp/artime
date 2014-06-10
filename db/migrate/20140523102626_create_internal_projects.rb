class CreateInternalProjects < ActiveRecord::Migration
  def change
    Company.all.each do |company|
      company.internal_projects
    end
  end
end
