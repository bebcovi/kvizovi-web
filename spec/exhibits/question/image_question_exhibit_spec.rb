require "spec_helper"

describe ImageQuestionExhibit do
  before do
    @question = Factory.build(:image_question)
    @it = ImageQuestionExhibit.new(@question)
  end

  it "inherits from TextQuestionExhibit" do
    expect(@it).to be_a(TextQuestionExhibit)
  end
end
