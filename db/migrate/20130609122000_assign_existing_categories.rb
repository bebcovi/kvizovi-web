class AssignExistingCategories < ActiveRecord::Migration
  class Quiz < ActiveRecord::Base
  end

  def up
    Quiz.update_all(category: "Hrvatski jezik")
  end

  def down
  end
end
