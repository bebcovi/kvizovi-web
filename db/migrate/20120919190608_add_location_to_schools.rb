class AddLocationToSchools < ActiveRecord::Migration
  def change
    add_column :schools, :place, :string
    add_column :schools, :region, :string
  end
end
