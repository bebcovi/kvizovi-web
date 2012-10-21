if defined?(RSpec)
  require "rspec/core/rake_task"

  class MyRSpecTask < RSpec::Core::RakeTask
    attr_accessor :spec_files

    def files_to_run
      if spec_files and not ENV["SPEC"]
        spec_files
      else
        super
      end
    end
  end

  namespace :spec do
    all_specs = FileList["spec/**/*_spec.rb"]
    integration_specs = FileList["spec/**/*_integration_spec.rb"] + FileList["spec/requests/**/*_spec.rb"]
    unit_specs = all_specs - integration_specs

    desc "Run unit tests"
    MyRSpecTask.new(:unit) do |t|
      t.spec_files = unit_specs
      t.verbose = true
    end

    desc "Run integration tests"
    MyRSpecTask.new(:integration) do |t|
      t.spec_files = integration_specs
      t.verbose = true
    end

    desc "Run factory specs"
    RSpec::Core::RakeTask.new(:factory) do |t|
      t.pattern = "spec/misc/factories_spec.rb"
      t.verbose = true
    end
  end
end
