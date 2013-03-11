require "spec_helper"

feature "Login" do
  scenario "visiting old login link" do
    visit login_path
    expect(current_path).to eq root_path
  end
end
