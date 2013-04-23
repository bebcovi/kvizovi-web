Given(/^I have the following (.*)$/) do |name, table|
  table.hashes.each do |attributes|
    Factory.create(name.singularize.gsub(" ", "_"), attributes)
  end
end
