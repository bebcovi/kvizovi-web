require "spec_helper_full"

describe "Tagging" do
  before(:all) {
    @school = create(:school)
    @question = create(:question, school: @school)
  }

  before(:each) { login(:school, attributes_for(:school)) }

  it "can be done through the form" do
    visit edit_school_question_path(@school, @question)

    fill_in "Tagovi", with: "Foo, Bar"
    click_on "Spremi"

    # Now we're on the index page
    fill_in "Tagovi", with: "Foo"
    click_on "Filtrirajte"
    page.should_not have_content("Nema pitanja s tim kategorijama.")

    # Now we're on the index page
    fill_in "Tagovi", with: "Bar"
    click_on "Filtrirajte"
    page.should_not have_content("Nema pitanja s tim kategorijama.")

    # Now we're on the index page
    fill_in "Tagovi", with: "Foo, Bar"
    click_on "Filtrirajte"
    page.should_not have_content("Nema pitanja s tim kategorijama.")

    # Now we're on the index page
    fill_in "Tagovi", with: "Baz"
    click_on "Filtrirajte"
    page.should have_content("Nema pitanja s tim kategorijama.")
  end

  after(:all) { @school.destroy }
end
