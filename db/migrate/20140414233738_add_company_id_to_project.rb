class AddCompanyIdToProject < ActiveRecord::Migration
  def change
    add_column :projects, :company_id, :integer
    add_index :projects, :company_id
  end
end
