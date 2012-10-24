class RemoveEmailOnStudents < ActiveRecord::Migration
  def up
    remove_column :students, :email
  end

  def down
    add_column :students, :email, :string
  end
end
