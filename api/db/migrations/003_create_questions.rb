Sequel.migration do
  change do
    create_table :questions do
      primary_key :id

      column :quiz_id, :integer

      column :type,     :varchar
      column :title,    :varchar
      column :content,  :jsonb
      column :image_id, :varchar
      column :hint,     :varchar

      column :position, :integer

      column :created_at, :timestamp
      column :updated_at, :timestamp
    end
  end
end
