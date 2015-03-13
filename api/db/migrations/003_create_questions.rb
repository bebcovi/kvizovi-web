Sequel.migration do
  change do
    create_table :questions do
      primary_key :id
      foreign_key :quiz_id, :quizzes

      column :type,     :varchar, null: false
      column :category, :varchar, null: false
      column :title,    :varchar, null: false
      column :content,  :jsonb,   null: false
      column :image,    :varchar
      column :hint,     :varchar

      column :position, :integer

      column :created_at, :timestamp
      column :updated_at, :timestamp
    end
  end
end
