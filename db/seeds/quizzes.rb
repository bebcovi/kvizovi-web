require "paperclip"

Paperclip.options[:log] = false

School.find_each do |school|
  ExampleQuizzesCreator.new(school).create
end
