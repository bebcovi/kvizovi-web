class AddDeviseToUsers < ActiveRecord::Migration
  def change
    [:schools, :students].each do |users_table|
      change_table users_table do |t|
        ## Database authenticatable
        t.rename :password_digest, :encrypted_password

        ## Recoverable
        t.string   :reset_password_token
        t.datetime :reset_password_sent_at

        ## Rememberable
        t.datetime :remember_created_at

        ## Confirmable
        t.string   :confirmation_token
        t.datetime :confirmed_at
        t.datetime :confirmation_sent_at
        t.string   :unconfirmed_email
        t.remove   :password_reset_confirmation_id
      end
    end
  end
end
