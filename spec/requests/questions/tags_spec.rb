require "spec_helper_full"

describe "Tagging" do
end

describe "Filtering tags" do
  before(:all) {
    @school = create(:school)
    @question = create(:question, school: @school)
  }

  before(:each) { login(:school, attributes_for(:school)) }

  def filter_with(tags)
    fill_in "filter_tags", with: tags
    within("#new_filter") { first("button").click }
  end

  describe "filtering" do
    before(:all) { @question.update_attributes(tag_list: "foo, bar") }
    before(:each) { visit school_questions_path(@school) }

    it "does the obvious" do
      filter_with("foo, bar")
      page.should have_content(@question.content)

      filter_with("foo")
      page.should have_content(@question.content)

      filter_with("bar")
      page.should have_content(@question.content)

      filter_with("baz")
      page.should_not have_content(@question.content)

      filter_with("foo, bar, baz")
      page.should_not have_content(@question.content)
    end

    it "is case insensitive" do
      filter_with("Foo, Bar")
      page.should have_content(@question.content)
    end
  end

  after(:all) {
    @question.destroy
    @school.destroy
  }
end
