class AddPasswordResetConfirmationIdToStudents < ActiveRecord::Migration
  def change
    add_column :students, :password_reset_confirmation_id, :string
  end
end
