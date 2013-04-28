class StoreAssociationsAsArray < ActiveRecord::Migration
  class Question < ActiveRecord::Base
  end

  class AssociationQuestion < Question
    serialize :data, Hash
  end

  def up
    AssociationQuestion.find_each do |question|
      question.update_attributes!(data: {associations: question.data[:associations].to_a})
    end
  end

  def down
    AssociationQuestion.find_each do |question|
      question.update_attributes!(data: {associations: Hash[question.data[:associations]]})
    end
  end
end
