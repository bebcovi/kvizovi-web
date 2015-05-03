require "kvizovi/mediators/gameplays"

module Kvizovi
  class App
    route "gameplays" do |r|
      r.post true do
        Mediators::Gameplays.create(resource(:gameplay))
      end

      r.get true do
        Mediators::Gameplays.new(current_user).search(params)
      end

      r.get ":id" do |id|
        Mediators::Gameplays.new(current_user).find(id)
      end
    end
  end
end
