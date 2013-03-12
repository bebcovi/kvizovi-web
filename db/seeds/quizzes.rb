School.find_each do |school|
  ExampleQuizzesCreator.new(school).create
end
