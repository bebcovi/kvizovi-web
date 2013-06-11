require "factory_girl"

FactoryGirl.factories.clear
FactoryGirl.definition_file_paths = ["features/support/factories"]
FactoryGirl.find_definitions
