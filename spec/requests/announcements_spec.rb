# encoding: utf-8
require "spec_helper_full"

describe "Announcements" do
  before(:all) { @school = create(:school) }
  before(:each) { login(:school, attributes_for(:school)) }

  before(:each) { @school.connection.execute %(UPDATE "schools" SET "notified" = 'f') }

  it "is shown when the logged in user is not notified" do
    visit quizzes_path
    page.should have_content("Napravili smo neke važne promjene")
  end

  it "can be viewed by the user, and then it isn't shown anymore" do
    visit quizzes_path
    within(".alert-info") { click_link("ovdje") }
    current_path.should eq updates_path
    page.should_not have_content("Napravili smo neke važne promjene")
    visit quizzes_path
    page.should_not have_content("Napravili smo neke važne promjene")
  end

  it "can be closed by the user, and then it isn't shown anymore" do
    visit quizzes_path
    within(".alert-info") { find(".close").click }
    current_path.should eq quizzes_path
    page.should_not have_content("Napravili smo neke važne promjene")
  end
end
