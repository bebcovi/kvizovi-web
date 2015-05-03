Sequel.migration do
  change do
    create_table :gameplays do
      primary_key :id

      column :quiz_id,       :integer
      column :quiz_snapshot, :jsonb

      column :player_ids, "integer[]"

      column :answers, :jsonb

      column :start,  :time
      column :finish, :time
    end
  end
end
