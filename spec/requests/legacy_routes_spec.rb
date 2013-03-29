require "spec_helper"

describe "Legacy routes" do
  they "still work" do
    request_via_redirect(:get, "login")
    request_via_redirect(:get, "schools/new")
    request_via_redirect(:get, "students/new")
  end
end
