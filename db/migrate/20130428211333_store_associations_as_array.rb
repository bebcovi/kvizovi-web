class StoreAssociationsAsArray < ActiveRecord::Migration
  class Question < ActiveRecord::Base
  end

  class AssociationQuestion < Question
    serialize :data, Hash
  end

  def up
    handle_single_table_inheritance(Question) do
      AssociationQuestion.find_each do |question|
        question.update_attributes!(data: {associations: question.data[:associations].to_a})
      end
    end
  end

  def down
    handle_single_table_inheritance(Question) do
      AssociationQuestion.find_each do |question|
        question.update_attributes!(data: {associations: Hash[question.data[:associations]]})
      end
    end
  end
end
