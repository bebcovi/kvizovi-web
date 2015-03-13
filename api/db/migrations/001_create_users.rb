Sequel.migration do
  change do
    create_table :users do
      primary_key :id
      foreign_key :teacher_id, :users

      column :nickname,           :varchar, null: false
      column :email,              :varchar, null: false, unique: true
      column :encrypted_password, :varchar
      column :token,              :varchar

      column :confirmation_token, :varchar
      column :confirmed_at,       :timestamp

      column :password_reset_token, :varchar

      column :created_at, :timestamp
      column :updated_at, :timestamp
    end
  end
end
