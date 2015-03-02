##########
# SEQUEL #
##########

require "sequel"
require "yaml"

environment = ENV["RACK_ENV"] || "development"
database_options = YAML.load_file("config/database.yml").fetch(environment)
DB = Sequel.connect(database_options)

Sequel::Model.raise_on_save_failure = true

Sequel::Model.plugin :validation_helpers
Sequel::Model.plugin :timestamps
Sequel::Model.plugin :json_serializer

DB.extension :pg_json

########
# MAIL #
########

require "mail"

Mail.defaults do
  delivery_method :smtp
end

