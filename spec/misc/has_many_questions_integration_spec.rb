require "spec_helper_full"

class CreateRecords < ActiveRecord::Migration
  def change
    create_table :records do |t|
    end
  end
end

module MyExtension
  def my_extension_method
  end
end

class Record < ActiveRecord::Base
  extend HasManyQuestions
  has_many_questions extend: MyExtension, foreign_key: "quiz_id"
end

describe HasManyQuestions do
  before(:all) do
    CreateRecords.verbose = false
    CreateRecords.migrate(:up)
  end
  after(:all) do
    CreateRecords.migrate(:down)
  end

  before(:each) { @record = Record.new }

  describe "#questions" do
    it "maps to Question class by default" do
      @record.questions.new.should be_a(Question)
    end

    it "accepts a category argument" do
      @record.questions("boolean").new.should be_a(BooleanQuestion)
    end
  end

  it "applies the options" do
    @record.questions.should respond_to(:my_extension_method)
    @record.questions("boolean").should respond_to(:my_extension_method)
  end
end
