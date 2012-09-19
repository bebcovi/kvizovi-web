class AddGenderAndYearOfBirthToStudents < ActiveRecord::Migration
  def change
    add_column :students, :gender, :string
    add_column :students, :year_of_birth, :integer
  end
end
