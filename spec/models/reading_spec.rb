require "spec_helper"

describe Reading do
  it "doesn't allow duplicates" do
    Reading.create!(post_id: 1, user_id: 1, user_type: "Student")
    duplicate = Reading.new(post_id: 1, user_id: 1, user_type: "Student")
    expect(duplicate).not_to be_valid
  end
end
