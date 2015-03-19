require "kvizovi"

require "refile"
require "refile/image_processing"

map "/" do
  run Kvizovi::API
end

map "/#{Refile.mount_point}" do
  run Refile::App
end
