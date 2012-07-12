guard :rails, :server => :thin, :timeout => 0 do
  watch('Gemfile.lock')
  watch(%r{lib/.*})
  watch(%r{config/application.rb})
  watch(%r{config/initializers/.*})
  watch(%r{app/inputs/.*})
end

guard :livereload do
  watch(%r{app/.+\.(haml|scss)})
end
