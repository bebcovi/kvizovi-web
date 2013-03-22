describe "Legacy routes" do
  they "still work" do
    get "login"
    get "schools/new"
    get "students/new"
  end
end
