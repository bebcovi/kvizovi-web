class AddFullTextSearchExtensions < ActiveRecord::Migration
  def up
    execute "create extension unaccent"
    execute "create extension pg_trgm"
  end

  def down
    execute "drop extension unaccent"
    execute "drop extension pg_trgm"
  end
end
