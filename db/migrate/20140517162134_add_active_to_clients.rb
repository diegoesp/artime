class AddActiveToClients < ActiveRecord::Migration
  def change
  	add_column :clients, :active, :boolean, null: false, default: true
  end
end