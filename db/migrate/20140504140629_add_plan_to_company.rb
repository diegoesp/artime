class AddPlanToCompany < ActiveRecord::Migration
  def change
  	add_column :companies, :plan_id, :integer
    add_index :companies, :plan_id
  end
end
