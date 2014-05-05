class CreatePlans < ActiveRecord::Migration
  def change
    create_table :plans do |t|
      t.string :name
      t.string :description
      t.boolean :active, null: false, default: true

      t.timestamps
    end
  end
end
