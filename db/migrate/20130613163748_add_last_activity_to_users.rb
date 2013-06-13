class AddLastActivityToUsers < ActiveRecord::Migration
  def change
    add_column :students, :last_activity, :datetime
    add_column :schools, :last_activity, :datetime
  end
end
