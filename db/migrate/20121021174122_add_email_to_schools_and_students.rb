class AddEmailToSchoolsAndStudents < ActiveRecord::Migration
  def change
    add_column :schools, :email, :string
    add_column :students, :email, :string
  end
end
