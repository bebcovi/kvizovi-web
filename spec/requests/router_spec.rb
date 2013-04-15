require "spec_helper"

describe "Router" do
  it "supports legacy routes" do
    request_via_redirect(:get, "login")
    request_via_redirect(:get, "schools/new")
    request_via_redirect(:get, "students/new")
  end
end
