class AddAdminToUser < ActiveRecord::Migration
  def up
    add_column :users, :admin, :boolean, :null => false, :default => false 
    User.create! do |r|
      r.email      = 'admin@example.com'
      r.password   = 'password'
      r.first_name = 'John'
      r.last_name= 'Admin'
      r.admin = true
    end
  end

  def down
    remove_column :users, :admin
    User.find_by_email('admin@example.com').try(:delete)
  end
end