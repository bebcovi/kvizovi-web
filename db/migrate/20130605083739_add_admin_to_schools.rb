class AddAdminToSchools < ActiveRecord::Migration
  def change
    add_column :schools, :admin, :boolean, default: false
  end
end
