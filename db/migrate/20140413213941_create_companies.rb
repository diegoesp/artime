class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.string :name
      t.boolean :active, null: false, default: true

      t.timestamps
    end
  end
end
