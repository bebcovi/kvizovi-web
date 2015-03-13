Sequel.migration do
  change do
    create_table :quizzes do
      primary_key :id
      foreign_key :creator_id, :users

      column :name,  :varchar, null: false
      column :image, :varchar

      column :created_at, :timestamp
      column :updated_at, :timestamp
    end
  end
end
