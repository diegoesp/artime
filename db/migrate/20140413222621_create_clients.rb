class CreateClients < ActiveRecord::Migration
  def change
    create_table :clients do |t|
      t.string :name
      t.references :company

      t.timestamps
    end
    add_index :clients, :company_id
  end
end
