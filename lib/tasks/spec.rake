require "rspec/core/rake_task"

namespace :spec do
  desc "Run unit tests"
  RSpec::Core::RakeTask.new(:unit) do |t|
    t.pattern = "spec/{models,helpers,misc}/**/*_spec.rb"
    t.verbose = true
  end

  desc "Run integration tests"
  RSpec::Core::RakeTask.new(:integration) do |t|
    t.pattern = "spec/{controllers,requests}/**/*_spec.rb"
    t.verbose = true
  end

  desc "Run factory specs"
  RSpec::Core::RakeTask.new(:factory) do |t|
    t.pattern = "spec/misc/factories_spec.rb"
    t.verbose = true
  end
end

Rake::Task[:spec].clear
desc "Run all tests"
task :spec => ["spec:unit", "spec:integration"]
