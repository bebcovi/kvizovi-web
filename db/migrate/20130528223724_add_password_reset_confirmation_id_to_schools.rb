class AddPasswordResetConfirmationIdToSchools < ActiveRecord::Migration
  def change
    add_column :schools, :password_reset_confirmation_id, :string
  end
end
