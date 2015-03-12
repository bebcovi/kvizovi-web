Sequel.migration do
  change do
    create_table :questions do
      primary_key :id
      foreign_key :quiz_id, :quizzes

      column :type,     :varchar
      column :category, :varchar
      column :title,    :varchar
      column :content,  :jsonb
      column :image,    :varchar
      column :hint,     :varchar

      column :position, :integer

      column :created_at, :timestamp
      column :updated_at, :timestamp
    end
  end
end
