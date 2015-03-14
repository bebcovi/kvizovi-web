Sequel.migration do
  change do
    create_table :quizzes do
      primary_key :id
      column :creator_id, :integer

      column :name,     :varchar
      column :category, :varchar
      column :image_id, :varchar

      column :created_at, :timestamp
      column :updated_at, :timestamp
    end
  end
end
