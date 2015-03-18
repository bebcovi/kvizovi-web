require "sequel"
require "yaml"

environment = ENV["RACK_ENV"] || "development"
database_options = YAML.load_file("config/database.yml").fetch(environment)
DB = Sequel.connect(database_options)

Sequel::Model.raise_on_save_failure = true

Sequel::Model.plugin :validation_helpers
Sequel::Model.plugin :timestamps, update_on_create: true
Sequel::Model.plugin :json_serializer
Sequel::Model.plugin :nested_attributes
Sequel::Model.plugin :association_dependencies
Sequel::Model.plugin :pg_array_associations

DB.extension :pg_array
DB.extension :pg_json
DB.extension :pagination

Sequel.extension :core_extensions
