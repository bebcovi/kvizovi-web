guard :rails, :server => :thin do
  watch('Gemfile.lock')
  watch(%r{^(config/lib)./*})
end

guard :livereload do
  watch(%r{app/.+\.(scss|coffee|hamlc)})
end
