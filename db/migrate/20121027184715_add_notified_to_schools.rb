class AddNotifiedToSchools < ActiveRecord::Migration
  def change
    add_column :schools, :notified, :boolean, default: true
  end
end
