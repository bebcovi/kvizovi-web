class RenameKindToLevelOnSchools < ActiveRecord::Migration
  def change
    rename_column :schools, :kind, :level
  end
end
