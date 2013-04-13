Given(/^I have the following (.*)$/) do |name, table|
  table.hashes.each do |attributes|
    FactoryGirl.create(name.singularize.gsub(" ", "_"), attributes)
  end
end
